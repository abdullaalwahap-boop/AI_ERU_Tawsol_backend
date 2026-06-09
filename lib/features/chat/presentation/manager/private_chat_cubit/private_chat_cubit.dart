import 'dart:async';

import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_ws_events.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'private_chat_state.dart';

class PrivateChatCubit extends Cubit<PrivateChatState> {
  PrivateChatCubit(this._repo, this._wsService, this._storage)
      : super(PrivateChatInitial());

  final ChatRepo _repo;
  final ChatWebSocketService _wsService;
  final SecureStorageService _storage;

  StreamSubscription<WsEvent>? _wsSub;
  Timer? _typingTimer;
  Timer? _pendingRefreshTimer;
  int? _myUserId;
  int? _partnerUserId;

  // FIFO queues of pending temp IDs, keyed by message type.
  // Ensures each server confirmation is matched to the correct optimistic
  // message regardless of duplicate content or URL changes after upload.
  final Map<MessageType, List<String>> _pendingByType = {};

  // ── Pending-send queue helpers ─────────────────────────────────────────────

  void _trackPending(String tempId, MessageType type) {
    _pendingByType.putIfAbsent(type, () => []).add(tempId);
  }

  void _removePending(String tempId, MessageType type) {
    _pendingByType[type]?.remove(tempId);
  }

  String? _popOldestPending(MessageType type) {
    final list = _pendingByType[type];
    if (list == null || list.isEmpty) return null;
    return list.removeAt(0);
  }

  // ── Timeout-based refresh (catches missed WS echoes) ──────────────────────

  void _schedulePendingRefresh() {
    _pendingRefreshTimer?.cancel();
    _pendingRefreshTimer = Timer(const Duration(seconds: 5), _refreshIfPending);
  }

  Future<void> _refreshIfPending() async {
    if (isClosed) return;
    if (_pendingByType.values.every((q) => q.isEmpty)) return;
    try {
      final fresh = await _repo.getMessages(_partnerUserId!.toString());
      if (isClosed) return;
      final current = state;
      if (current is! PrivateChatLoaded) return;
      _pendingByType.clear();
      emit(_withMessages(current, fresh));
    } catch (_) {}
  }

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadMessages(String partnerUserIdStr) async {
    _myUserId = await _storage.getUserId();
    _partnerUserId = int.tryParse(partnerUserIdStr);
    if (_partnerUserId == null || _myUserId == null) {
      emit(const PrivateChatError('Invalid session.'));
      return;
    }

    _pendingByType.clear();
    emit(PrivateChatLoading());
    try {
      await _wsService.ensureConnected();
      final messages = await _repo.getMessages(partnerUserIdStr);
      if (isClosed) return;
      emit(PrivateChatLoaded(messages: messages));
      _subscribeToWsEvents();
      _wsService.sendSeen(_partnerUserId!);
    } catch (e) {
      if (isClosed) return;
      emit(PrivateChatError(e.toString()));
    }
  }

  // ── WebSocket event subscription ───────────────────────────────────────────

  void _subscribeToWsEvents() {
    _wsSub?.cancel();
    _wsSub = _wsService.events.listen((event) {
      switch (event) {
        case WsMessageReceivedEvent(:final data):
          final senderId = data['sender_id'] as int?;
          if (senderId == _partnerUserId) _onIncomingMessage(data);

        case WsMessageSentEvent(:final data):
          final senderId = data['sender_id'] as int?;
          if (senderId == _myUserId) _onMessageConfirmed(data);

        case WsTypingEvent(:final senderId, :final isTyping):
          if (senderId == _partnerUserId) _onTyping(isTyping);

        case WsSeenEvent(:final receiverId):
          if (receiverId == _partnerUserId) _onAllMessagesSeen();

        case WsDeliveredEvent(:final receiverId):
          if (receiverId == _partnerUserId) _onMessagesDelivered();

        case WsMessageEditedEvent(
            :final chatId,
            :final newText,
            :final editedAt
          ):
          _onMessageEdited(chatId, newText, editedAt);

        case WsMessageDeletedEvent(:final chatId):
          _onMessageDeleted(chatId);

        case WsErrorEvent(:final detail):
          _onSendError(detail);

        default:
          break;
      }
    });
  }

  // ── Incoming message ───────────────────────────────────────────────────────

  void _onIncomingMessage(Map<String, dynamic> data) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final msg = ChatMessage.fromJson(data, myUserId: _myUserId ?? 0);
    if (current.messages.any((m) => m.id == msg.id)) return;
    final updated = List<ChatMessage>.from(current.messages)..add(msg);
    emit(_withMessages(current, updated, isOtherTyping: false));
    _wsService.sendSeen(_partnerUserId!);
  }

  // ── Sent confirmation (replaces optimistic temp message) ──────────────────

  void _onMessageConfirmed(Map<String, dynamic> data) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final confirmed = ChatMessage.fromJson(data, myUserId: _myUserId ?? 0);
    final messages = current.messages.toList();

    // Dedup: if the confirmed ID is already in the list (e.g. after refresh),
    // there is nothing to do.
    if (messages.any((m) => m.id == confirmed.id)) return;

    // Pop the oldest pending temp for this type and replace it.
    final tempId = _popOldestPending(confirmed.type);
    final idx =
        tempId != null ? messages.indexWhere((m) => m.id == tempId) : -1;

    if (idx != -1) {
      final existing = messages[idx];
      messages[idx] = confirmed.copyWith(
        fileUrl: confirmed.fileUrl ?? existing.fileUrl,
        voiceDuration: confirmed.voiceDuration ?? existing.voiceDuration,
      );
    } else {
      // No matching temp (e.g. list was refreshed and temp is gone).
      // Safe to append since the dedup check above already ran.
      messages.add(confirmed);
    }
    emit(_withMessages(current, messages));
  }

  // ── Typing indicator ───────────────────────────────────────────────────────

  void _onTyping(bool isTyping) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    _typingTimer?.cancel();
    emit(current.copyWith(isOtherTyping: isTyping));
    if (isTyping) {
      _typingTimer = Timer(const Duration(seconds: 5), () {
        final s = state;
        if (s is PrivateChatLoaded && s.isOtherTyping) {
          emit(s.copyWith(isOtherTyping: false));
        }
      });
    }
  }

  // ── Read receipts ──────────────────────────────────────────────────────────

  void _onAllMessagesSeen() {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final updated = current.messages
        .map((m) => m.isFromMe ? m.copyWith(status: MessageStatus.seen) : m)
        .toList();
    emit(_withMessages(current, updated));
  }

  void _onMessagesDelivered() {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final updated = current.messages
        .map((m) => m.isFromMe && m.status == MessageStatus.sending
            ? m.copyWith(status: MessageStatus.delivered)
            : m)
        .toList();
    emit(_withMessages(current, updated));
  }

  // ── Message edited (from partner via WS) ──────────────────────────────────

  void _onMessageEdited(int chatId, String newText, String editedAt) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final messages = current.messages.map((m) {
      if (m.id == chatId.toString()) {
        return m.copyWith(
          text: newText,
          editedAt: DateTime.tryParse(editedAt),
        );
      }
      return m;
    }).toList();
    emit(_withMessages(current, messages));
  }

  // ── Message deleted (from partner via WS) ─────────────────────────────────

  void _onMessageDeleted(int chatId) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final messages = current.messages.map((m) {
      if (m.id == chatId.toString()) return m.copyWith(isDeleted: true);
      return m;
    }).toList();
    emit(_withMessages(current, messages));
  }

  // ── Server send error ─────────────────────────────────────────────────────

  void _onSendError(String detail) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final messages = current.messages
        .where((m) => m.status != MessageStatus.sending)
        .toList();
    emit(_withMessages(current, messages, sendError: detail));
  }

  // ── Reply ──────────────────────────────────────────────────────────────────

  void setReplyTo(ChatMessage? message) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    if (message == null) {
      emit(current.copyWith(clearReplyingTo: true));
    } else {
      emit(current.copyWith(replyingTo: message));
    }
  }

  // ── Send ───────────────────────────────────────────────────────────────────

  Future<void> sendTextMessage(String text) async {
    final current = state;
    if (current is! PrivateChatLoaded ||
        _partnerUserId == null ||
        _myUserId == null) {
      return;
    }

    final replyToId = current.replyingTo?.id;
    final replyToIdInt = replyToId != null ? int.tryParse(replyToId) : null;

    final temp = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _myUserId.toString(),
      type: MessageType.text,
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      isFromMe: true,
      replyToId: replyToId,
    );
    final optimistic = List<ChatMessage>.from(current.messages)..add(temp);
    emit(_withMessages(current, optimistic,
        isOtherTyping: false, clearReplyingTo: true));
    _trackPending(temp.id, MessageType.text);

    if (_wsService.isConnected) {
      _wsService.sendText(
        receiverId: _partnerUserId!,
        text: text,
        replyToId: replyToIdInt,
      );
      _schedulePendingRefresh();
    } else {
      // WS offline: send via REST so the message is saved even without a socket.
      try {
        final confirmed = await _repo.sendMessage(
          receiverId: _partnerUserId!,
          contentType: 'text',
          message: text,
          replyToId: replyToIdInt,
        );
        if (isClosed) return;
        _removePending(temp.id, MessageType.text);
        final s = state;
        if (s is PrivateChatLoaded) {
          final msgs =
              s.messages.map((m) => m.id == temp.id ? confirmed : m).toList();
          emit(_withMessages(s, msgs));
        }
      } catch (_) {
        if (isClosed) return;
        _removePending(temp.id, MessageType.text);
        final s = state;
        if (s is PrivateChatLoaded) {
          final msgs = s.messages.where((m) => m.id != temp.id).toList();
          emit(_withMessages(s, msgs, sendError: 'Failed to send message.'));
        }
      }
    }
  }

  Future<void> sendVoiceMessage({
    required String filePath,
    required int durationSeconds,
  }) async {
    final current = state;
    if (current is! PrivateChatLoaded ||
        _partnerUserId == null ||
        _myUserId == null) {
      return;
    }

    final replyToId = current.replyingTo?.id;
    final replyToIdInt = replyToId != null ? int.tryParse(replyToId) : null;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final temp = ChatMessage(
      id: tempId,
      senderId: _myUserId.toString(),
      type: MessageType.voice,
      voiceDuration: Duration(seconds: durationSeconds),
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      isFromMe: true,
      replyToId: replyToId,
    );
    final optimistic = List<ChatMessage>.from(current.messages)..add(temp);
    emit(_withMessages(current, optimistic, clearReplyingTo: true));
    _trackPending(tempId, MessageType.voice);

    try {
      final upload = await _repo.uploadVoiceFile(filePath);
      if (isClosed) return;

      if (_wsService.isConnected) {
        _wsService.sendVoice(
          receiverId: _partnerUserId!,
          durationSeconds: durationSeconds,
          fileUrl: upload.fileUrl,
          fileName: upload.fileName,
          fileSizeBytes: upload.fileSizeBytes,
          replyToId: replyToIdInt,
        );
        _schedulePendingRefresh();
      } else {
        // WS offline: send via REST with the already-uploaded file URL.
        try {
          final confirmed = await _repo.sendMessage(
            receiverId: _partnerUserId!,
            contentType: 'voice',
            fileUrl: upload.fileUrl,
            fileName: upload.fileName,
            fileSizeBytes: upload.fileSizeBytes,
            voiceDurationSeconds: durationSeconds,
            replyToId: replyToIdInt,
          );
          if (isClosed) return;
          _removePending(tempId, MessageType.voice);
          final s = state;
          if (s is PrivateChatLoaded) {
            final msgs = s.messages
                .map((m) => m.id == tempId ? confirmed : m)
                .toList();
            emit(_withMessages(s, msgs));
          }
        } catch (_) {
          if (isClosed) return;
          _removePending(tempId, MessageType.voice);
          final s = state;
          if (s is PrivateChatLoaded) {
            final msgs = s.messages.where((m) => m.id != tempId).toList();
            emit(_withMessages(s, msgs));
          }
        }
      }
    } catch (_) {
      if (isClosed) return;
      _removePending(tempId, MessageType.voice);
      final s = state;
      if (s is PrivateChatLoaded) {
        final msgs = s.messages.where((m) => m.id != tempId).toList();
        emit(_withMessages(s, msgs));
      }
    }
  }

  // ── Send attachment (image / file / audio) ────────────────────────────────

  Future<void> sendAttachment({
    required String filePath,
    required String fileName,
    required String pickedType,
  }) async {
    final current = state;
    if (current is! PrivateChatLoaded ||
        _partnerUserId == null ||
        _myUserId == null) {
      return;
    }

    final replyToId = current.replyingTo?.id;
    final replyToIdInt = replyToId != null ? int.tryParse(replyToId) : null;

    final msgType = switch (pickedType) {
      'image' || 'video' => MessageType.image,
      'audio' => MessageType.voice,
      _ => MessageType.file,
    };
    final wsContentType = switch (pickedType) {
      'image' || 'video' => 'image',
      'audio' => 'audio',
      _ => 'file',
    };

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final temp = ChatMessage(
      id: tempId,
      senderId: _myUserId.toString(),
      type: msgType,
      fileName: fileName,
      fileUrl: filePath,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      isFromMe: true,
      replyToId: replyToId,
    );
    final optimistic = List<ChatMessage>.from(current.messages)..add(temp);
    emit(_withMessages(current, optimistic, clearReplyingTo: true));
    _trackPending(tempId, msgType);

    try {
      final upload = await _repo.uploadFile(filePath);
      if (isClosed) return;

      if (_wsService.isConnected) {
        _wsService.sendFile(
          receiverId: _partnerUserId!,
          contentType: wsContentType,
          fileUrl: upload.fileUrl,
          fileName: upload.fileName ?? fileName,
          fileSizeBytes: upload.fileSizeBytes ?? 0,
          replyToId: replyToIdInt,
        );
        _schedulePendingRefresh();

        // Update temp with the remote URL while waiting for WS echo.
        final s = state;
        if (s is PrivateChatLoaded) {
          final msgs = s.messages.map((m) {
            if (m.id == tempId) {
              return m.copyWith(
                fileUrl: upload.fileUrl,
                fileName: upload.fileName ?? fileName,
                fileSizeMB: upload.fileSizeBytes != null
                    ? upload.fileSizeBytes! / (1024 * 1024)
                    : null,
              );
            }
            return m;
          }).toList();
          emit(_withMessages(s, msgs));
        }
      } else {
        // WS offline: send via REST with the already-uploaded file URL.
        try {
          final confirmed = await _repo.sendMessage(
            receiverId: _partnerUserId!,
            contentType: wsContentType,
            fileUrl: upload.fileUrl,
            fileName: upload.fileName ?? fileName,
            fileSizeBytes: upload.fileSizeBytes,
            replyToId: replyToIdInt,
          );
          if (isClosed) return;
          _removePending(tempId, msgType);
          final s = state;
          if (s is PrivateChatLoaded) {
            final msgs = s.messages
                .map((m) => m.id == tempId ? confirmed : m)
                .toList();
            emit(_withMessages(s, msgs));
          }
        } catch (_) {
          if (isClosed) return;
          _removePending(tempId, msgType);
          final s = state;
          if (s is PrivateChatLoaded) {
            final msgs = s.messages.where((m) => m.id != tempId).toList();
            emit(_withMessages(s, msgs, sendError: 'Failed to send file.'));
          }
        }
      }
    } catch (_) {
      if (isClosed) return;
      _removePending(tempId, msgType);
      final s = state;
      if (s is PrivateChatLoaded) {
        final msgs = s.messages.where((m) => m.id != tempId).toList();
        emit(_withMessages(s, msgs, sendError: 'Failed to upload file.'));
      }
    }
  }

  // ── Edit message ───────────────────────────────────────────────────────────

  Future<void> editMessage(String chatId, String newText) async {
    final current = state;
    if (current is! PrivateChatLoaded) return;

    final now = DateTime.now();
    final optimistic = current.messages.map((m) {
      if (m.id == chatId) return m.copyWith(text: newText, editedAt: now);
      return m;
    }).toList();
    emit(_withMessages(current, optimistic));

    try {
      final confirmed = await _repo.editMessage(chatId, newText);
      final s = state;
      if (s is! PrivateChatLoaded) return;
      final updated =
          s.messages.map((m) => m.id == chatId ? confirmed : m).toList();
      emit(_withMessages(s, updated));
    } catch (_) {
      emit(current);
    }
  }

  // ── Delete message ─────────────────────────────────────────────────────────

  Future<void> deleteMessage(String chatId) async {
    final current = state;
    if (current is! PrivateChatLoaded) return;

    final optimistic = current.messages.map((m) {
      if (m.id == chatId) return m.copyWith(isDeleted: true);
      return m;
    }).toList();
    emit(_withMessages(current, optimistic));

    try {
      await _repo.deleteMessage(chatId);
    } catch (_) {
      emit(current);
    }
  }

  // ── Typing indicator (outgoing) ────────────────────────────────────────────

  void notifyTyping(bool isTyping) {
    if (_partnerUserId == null) return;
    _wsService.sendTyping(receiverId: _partnerUserId!, isTyping: isTyping);
  }

  // ── Search within conversation ─────────────────────────────────────────────

  void toggleSearch() {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    emit(current.copyWith(
      isSearching: !current.isSearching,
      searchQuery: '',
      searchResults: const <String>[],
      searchResultIndex: 0,
    ));
  }

  void searchMessages(String query) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final results = _computeSearchResults(current.messages, query);
    // Start at the newest match.
    final idx = results.isEmpty ? 0 : results.length - 1;
    emit(current.copyWith(
      searchQuery: query,
      searchResults: results,
      searchResultIndex: idx,
    ));
  }

  /// Go to the next newer result (higher index = more recent message).
  void navigateSearchUp() {
    final current = state;
    if (current is! PrivateChatLoaded || current.searchResults.isEmpty) return;
    final newIdx =
        (current.searchResultIndex + 1).clamp(0, current.searchResults.length - 1);
    if (newIdx == current.searchResultIndex) return;
    emit(current.copyWith(searchResultIndex: newIdx));
  }

  /// Go to the next older result (lower index = earlier message).
  void navigateSearchDown() {
    final current = state;
    if (current is! PrivateChatLoaded || current.searchResults.isEmpty) return;
    final newIdx =
        (current.searchResultIndex - 1).clamp(0, current.searchResults.length - 1);
    if (newIdx == current.searchResultIndex) return;
    emit(current.copyWith(searchResultIndex: newIdx));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns message IDs (oldest-first) that match [query] in text or fileName.
  List<String> _computeSearchResults(
      List<ChatMessage> messages, String query) {
    if (query.isEmpty) return const <String>[];
    final lower = query.toLowerCase();
    return messages
        .where((m) =>
            (m.text?.toLowerCase().contains(lower) ?? false) ||
            (m.fileName?.toLowerCase().contains(lower) ?? false))
        .map((m) => m.id)
        .toList();
  }

  /// Builds a new state with [msgs] as the message list, re-computing search
  /// results if a search is currently active.
  PrivateChatLoaded _withMessages(
    PrivateChatLoaded s,
    List<ChatMessage> msgs, {
    String? sendError,
    bool clearReplyingTo = false,
    bool? isOtherTyping,
  }) {
    List<String> results = s.searchResults;
    int idx = s.searchResultIndex;
    if (s.isSearching && s.searchQuery.isNotEmpty) {
      results = _computeSearchResults(msgs, s.searchQuery);
      idx = results.isEmpty ? 0 : idx.clamp(0, results.length - 1);
    }
    return s.copyWith(
      messages: msgs,
      searchResults: results,
      searchResultIndex: idx,
      sendError: sendError,
      clearReplyingTo: clearReplyingTo,
      isOtherTyping: isOtherTyping,
    );
  }

  @override
  Future<void> close() {
    _wsSub?.cancel();
    _typingTimer?.cancel();
    _pendingRefreshTimer?.cancel();
    return super.close();
  }
}
