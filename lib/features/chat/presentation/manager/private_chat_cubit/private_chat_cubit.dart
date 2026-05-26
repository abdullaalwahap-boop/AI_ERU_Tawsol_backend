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
  int? _myUserId;
  int? _partnerUserId;

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadMessages(String partnerUserIdStr) async {
    _myUserId = await _storage.getUserId();
    _partnerUserId = int.tryParse(partnerUserIdStr);
    if (_partnerUserId == null || _myUserId == null) {
      emit(const PrivateChatError('Invalid session.'));
      return;
    }

    emit(PrivateChatLoading());
    try {
      await _wsService.ensureConnected();
      final messages = await _repo.getMessages(partnerUserIdStr);
      if (isClosed) return;
      emit(PrivateChatLoaded(messages: messages, filteredMessages: messages));
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
    final updated = List<ChatMessage>.from(current.messages)..add(msg);
    emit(current.copyWith(
      messages: updated,
      filteredMessages: _applySearch(updated, current.searchQuery),
      isOtherTyping: false,
    ));
    _wsService.sendSeen(_partnerUserId!);
  }

  // ── Sent confirmation (replaces optimistic temp message) ──────────────────

  void _onMessageConfirmed(Map<String, dynamic> data) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final confirmed = ChatMessage.fromJson(data, myUserId: _myUserId ?? 0);
    final messages = current.messages.toList();
    // For text: match by type + text content.
    // For file/image/audio: match by type + fileName (text is null for these).
    // For voice: match by type (fileName may differ after upload rename).
    final idx = messages.indexWhere((m) {
      if (m.status != MessageStatus.sending || !m.isFromMe) return false;
      if (m.type != confirmed.type) return false;
      if (m.type == MessageType.text) return m.text == confirmed.text;
      if (m.type == MessageType.voice) return true; // only one voice at a time
      return m.fileName == confirmed.fileName || m.fileUrl == confirmed.fileUrl;
    });
    if (idx != -1) {
      final existing = messages[idx];
      messages[idx] = confirmed.copyWith(
        fileUrl: confirmed.fileUrl ?? existing.fileUrl,
        voiceDuration: confirmed.voiceDuration ?? existing.voiceDuration,
      );
    } else {
      messages.add(confirmed);
    }
    emit(current.copyWith(
      messages: messages,
      filteredMessages: _applySearch(messages, current.searchQuery),
    ));
  }

  // ── Typing indicator ───────────────────────────────────────────────────────

  void _onTyping(bool isTyping) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    _typingTimer?.cancel();
    emit(current.copyWith(isOtherTyping: isTyping));
    if (isTyping) {
      // Auto-clear after 5 s in case the partner disconnects mid-typing.
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
    emit(current.copyWith(
      messages: updated,
      filteredMessages: _applySearch(updated, current.searchQuery),
    ));
  }

  void _onMessagesDelivered() {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final updated = current.messages
        .map((m) => m.isFromMe && m.status == MessageStatus.sending
            ? m.copyWith(status: MessageStatus.delivered)
            : m)
        .toList();
    emit(current.copyWith(
      messages: updated,
      filteredMessages: _applySearch(updated, current.searchQuery),
    ));
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
    emit(current.copyWith(
      messages: messages,
      filteredMessages: _applySearch(messages, current.searchQuery),
    ));
  }

  // ── Message deleted (from partner via WS) ─────────────────────────────────

  void _onMessageDeleted(int chatId) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    final messages = current.messages.map((m) {
      if (m.id == chatId.toString()) return m.copyWith(isDeleted: true);
      return m;
    }).toList();
    emit(current.copyWith(
      messages: messages,
      filteredMessages: _applySearch(messages, current.searchQuery),
    ));
  }

  // ── Server send error ─────────────────────────────────────────────────────

  void _onSendError(String detail) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    // Roll back any optimistic messages that are still in "sending" state.
    final messages = current.messages
        .where((m) => m.status != MessageStatus.sending)
        .toList();
    emit(current.copyWith(
      messages: messages,
      filteredMessages: _applySearch(messages, current.searchQuery),
      sendError: detail,
    ));
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
    emit(current.copyWith(
      messages: optimistic,
      filteredMessages: _applySearch(optimistic, current.searchQuery),
      isOtherTyping: false,
      clearReplyingTo: true,
    ));

    if (_wsService.isConnected) {
      _wsService.sendText(
        receiverId: _partnerUserId!,
        text: text,
        replyToId: replyToIdInt,
      );
    } else {
      try {
        await _repo.markSeen(_partnerUserId.toString());
        final msgs = (state as PrivateChatLoaded).messages.toList();
        final idx = msgs.indexWhere((m) => m.id == temp.id);
        if (idx != -1) msgs[idx] = temp.copyWith(status: MessageStatus.sent);
        final s = state as PrivateChatLoaded;
        emit(s.copyWith(
          messages: msgs,
          filteredMessages: _applySearch(msgs, s.searchQuery),
        ));
      } catch (_) {}
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
    emit(current.copyWith(
      messages: optimistic,
      filteredMessages: _applySearch(optimistic, current.searchQuery),
      clearReplyingTo: true,
    ));

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
      }
    } catch (_) {
      if (isClosed) return;
      final s = state;
      if (s is PrivateChatLoaded) {
        final msgs = s.messages.where((m) => m.id != tempId).toList();
        emit(s.copyWith(
          messages: msgs,
          filteredMessages: _applySearch(msgs, s.searchQuery),
        ));
      }
    }
  }

  // ── Send attachment (image / file / audio) ────────────────────────────────

  Future<void> sendAttachment({
    required String filePath,
    required String fileName,
    required String pickedType, // 'image' | 'video' | 'audio' | 'file'
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
      fileUrl: filePath, // local path for optimistic display
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      isFromMe: true,
      replyToId: replyToId,
    );
    final optimistic = List<ChatMessage>.from(current.messages)..add(temp);
    emit(current.copyWith(
      messages: optimistic,
      filteredMessages: _applySearch(optimistic, current.searchQuery),
      clearReplyingTo: true,
    ));

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
      }

      // Update temp message with real server URL immediately.
      final s = state;
      if (s is PrivateChatLoaded) {
        final msgs = s.messages.map((m) {
          if (m.id == tempId) {
            return m.copyWith(fileUrl: upload.fileUrl, fileName: upload.fileName ?? fileName);
          }
          return m;
        }).toList();
        emit(s.copyWith(
          messages: msgs,
          filteredMessages: _applySearch(msgs, s.searchQuery),
        ));
      }
    } catch (_) {
      if (isClosed) return;
      final s = state;
      if (s is PrivateChatLoaded) {
        final msgs = s.messages.where((m) => m.id != tempId).toList();
        emit(s.copyWith(
          messages: msgs,
          filteredMessages: _applySearch(msgs, s.searchQuery),
          sendError: 'Failed to upload file.',
        ));
      }
    }
  }

  // ── Edit message ───────────────────────────────────────────────────────────

  Future<void> editMessage(String chatId, String newText) async {
    final current = state;
    if (current is! PrivateChatLoaded) return;

    // Optimistic update.
    final now = DateTime.now();
    final optimistic = current.messages.map((m) {
      if (m.id == chatId) return m.copyWith(text: newText, editedAt: now);
      return m;
    }).toList();
    emit(current.copyWith(
      messages: optimistic,
      filteredMessages: _applySearch(optimistic, current.searchQuery),
    ));

    try {
      final confirmed = await _repo.editMessage(chatId, newText);
      final s = state;
      if (s is! PrivateChatLoaded) return;
      final updated =
          s.messages.map((m) => m.id == chatId ? confirmed : m).toList();
      emit(s.copyWith(
        messages: updated,
        filteredMessages: _applySearch(updated, s.searchQuery),
      ));
    } catch (_) {
      // Revert on failure.
      emit(current);
    }
  }

  // ── Delete message ─────────────────────────────────────────────────────────

  Future<void> deleteMessage(String chatId) async {
    final current = state;
    if (current is! PrivateChatLoaded) return;

    // Optimistic update.
    final optimistic = current.messages.map((m) {
      if (m.id == chatId) return m.copyWith(isDeleted: true);
      return m;
    }).toList();
    emit(current.copyWith(
      messages: optimistic,
      filteredMessages: _applySearch(optimistic, current.searchQuery),
    ));

    try {
      await _repo.deleteMessage(chatId);
    } catch (_) {
      // Revert on failure.
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
      filteredMessages: current.messages,
    ));
  }

  void searchMessages(String query) {
    final current = state;
    if (current is! PrivateChatLoaded) return;
    emit(current.copyWith(
      searchQuery: query,
      filteredMessages: _applySearch(current.messages, query),
    ));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<ChatMessage> _applySearch(List<ChatMessage> messages, String query) {
    if (query.isEmpty) return messages;
    return messages
        .where(
            (m) => m.text?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
  }

  @override
  Future<void> close() {
    _wsSub?.cancel();
    _typingTimer?.cancel();
    return super.close();
  }
}
