import 'dart:async';

import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_ws_events.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._repo, this._wsService, this._storage) : super(ChatInitial());

  final ChatRepo _repo;
  final ChatWebSocketService _wsService;
  final SecureStorageService _storage;

  Timer? _searchDebounce;
  StreamSubscription<WsEvent>? _wsSub;
  int? _myUserId;
  String? _openChatPartnerId;
  // Guards against stale async results when user types quickly in new-chat sheet.
  String _activeNewUserQuery = '';

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadConversations() async {
    emit(ChatLoading());
    try {
      _myUserId ??= await _storage.getUserId();
      await _wsService.ensureConnected();
      final conversations = await _repo.getConversations();
      if (isClosed) return;
      final list = _filterSelf(conversations);
      emit(ChatLoaded(conversations: list, filtered: list));
      _subscribeToWsEvents();
    } catch (e) {
      if (isClosed) return;
      emit(ChatError(e.toString()));
    }
  }

  // ── Refresh ────────────────────────────────────────────────────────────────

  Future<void> refresh() async {
    final current = state;
    if (current is! ChatLoaded) return;
    try {
      final conversations = await _repo.getConversations();
      if (isClosed) return;
      final list = _filterSelf(conversations);
      emit(current.copyWith(
        conversations: list,
        filtered: _applyFilter(list, current.query),
      ));
    } catch (_) {}
  }

  // ── Track open chat (clears unread count instantly) ───────────────────────

  void openChat(String partnerId) {
    _openChatPartnerId = partnerId;
    final current = state;
    if (current is! ChatLoaded) return;
    final conversations = current.conversations
        .map((c) =>
            c.otherUser.id == partnerId ? c.copyWith(unreadCount: 0) : c)
        .toList();
    emit(current.copyWith(
      conversations: conversations,
      filtered: _applyFilter(conversations, current.query),
    ));
  }

  void closeChat() {
    _openChatPartnerId = null;
  }

  // ── Conversation search (header — client-side only) ────────────────────────

  void toggleSearch() {
    final current = state;
    if (current is! ChatLoaded) return;
    if (current.isSearching) {
      emit(current.copyWith(
        isSearching: false,
        query: '',
        filtered: current.conversations,
      ));
    } else {
      emit(current.copyWith(isSearching: true));
    }
  }

  /// Filters existing conversations locally — no backend call.
  void searchConversations(String query) {
    final current = state;
    if (current is! ChatLoaded) return;
    emit(current.copyWith(
      query: query,
      filtered: _applyFilter(current.conversations, query),
    ));
  }

  // ── New-chat user search (FAB sheet — backend) ────────────────────────────

  /// Triggers a debounced backend user search for the "New Chat" sheet.
  void searchNewUsers(String q) {
    _searchDebounce?.cancel();
    final current = state;
    if (current is! ChatLoaded) return;

    if (q.isEmpty) {
      _activeNewUserQuery = '';
      emit(current.copyWith(
        userSearchResults: const [],
        isLoadingUserSearch: false,
      ));
      return;
    }

    emit(current.copyWith(isLoadingUserSearch: true));
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => _doSearchNewUsers(q),
    );
  }

  /// Clears new-user search results — call when the "New Chat" sheet closes.
  void clearNewUserSearch() {
    _searchDebounce?.cancel();
    _activeNewUserQuery = '';
    final current = state;
    if (current is! ChatLoaded) return;
    emit(current.copyWith(
      userSearchResults: const [],
      isLoadingUserSearch: false,
    ));
  }

  Future<void> _doSearchNewUsers(String q) async {
    _activeNewUserQuery = q;
    final current = state;
    if (current is! ChatLoaded) return;
    try {
      final results = await _repo.searchUsers(q);
      if (isClosed || _activeNewUserQuery != q) return;
      final loaded = state;
      if (loaded is! ChatLoaded) return;
      emit(loaded.copyWith(
        userSearchResults: results,
        isLoadingUserSearch: false,
      ));
    } catch (_) {
      if (isClosed || _activeNewUserQuery != q) return;
      final loaded = state;
      if (loaded is ChatLoaded) {
        emit(loaded.copyWith(isLoadingUserSearch: false));
      }
    }
  }

  // ── WebSocket subscription (real-time conversation list updates) ───────────

  void _subscribeToWsEvents() {
    _wsSub?.cancel();
    _wsSub = _wsService.events.listen((event) {
      switch (event) {
        case WsMessageSentEvent(:final data):
          final receiverId = (data['receiver_id'] as int?)?.toString();
          if (receiverId != null) {
            _updateConversationWithMessage(partnerId: receiverId, data: data);
          }

        case WsMessageReceivedEvent(:final data):
          final senderId = (data['sender_id'] as int?)?.toString();
          if (senderId != null) {
            _updateConversationWithMessage(
              partnerId: senderId,
              data: data,
              incrementUnread: _openChatPartnerId != senderId,
            );
          }

        case WsMessageEditedEvent(:final chatId, :final newText):
          _onLastMessageEdited(chatId, newText);

        case WsMessageDeletedEvent(:final chatId):
          _onLastMessageDeleted(chatId);

        default:
          break;
      }
    });
  }

  void _onLastMessageEdited(int chatId, String newText) {
    final current = state;
    if (current is! ChatLoaded) return;
    final conversations = current.conversations.map((c) {
      if (c.lastMessage?.id == chatId.toString()) {
        return c.copyWith(lastMessage: c.lastMessage!.copyWith(text: newText));
      }
      return c;
    }).toList();
    emit(current.copyWith(
      conversations: conversations,
      filtered: _applyFilter(conversations, current.query),
    ));
  }

  void _onLastMessageDeleted(int chatId) {
    final current = state;
    if (current is! ChatLoaded) return;
    final conversations = current.conversations.map((c) {
      if (c.lastMessage?.id == chatId.toString()) {
        return c.copyWith(
          lastMessage: c.lastMessage!.copyWith(isDeleted: true),
          unreadCount: c.unreadCount > 0 ? c.unreadCount - 1 : 0,
        );
      }
      return c;
    }).toList();
    emit(current.copyWith(
      conversations: conversations,
      filtered: _applyFilter(conversations, current.query),
    ));
  }

  /// Syncs the chat list's last message after exiting a private chat.
  /// Covers sender-side edits/deletes that don't emit WS events back to self.
  void syncLastMessage(String partnerId, ChatMessage? lastMsg) {
    final current = state;
    if (current is! ChatLoaded || lastMsg == null) return;
    final conversations = current.conversations.map((c) {
      if (c.otherUser.id == partnerId) return c.copyWith(lastMessage: lastMsg);
      return c;
    }).toList();
    emit(current.copyWith(
      conversations: conversations,
      filtered: _applyFilter(conversations, current.query),
    ));
  }

  void _updateConversationWithMessage({
    required String partnerId,
    required Map<String, dynamic> data,
    bool incrementUnread = false,
  }) {
    final current = state;
    if (current is! ChatLoaded || _myUserId == null) return;

    final newMsg = ChatMessage.fromJson(data, myUserId: _myUserId!);
    final conversations = current.conversations.toList();
    final idx = conversations.indexWhere((c) => c.otherUser.id == partnerId);

    if (idx == -1) {
      refresh();
      return;
    }

    final convo = conversations[idx];
    final updated = convo.copyWith(
      lastMessage: newMsg,
      unreadCount: incrementUnread ? convo.unreadCount + 1 : convo.unreadCount,
    );

    conversations.removeAt(idx);

    if (convo.isPinned) {
      conversations.insert(idx, updated);
    } else {
      final firstNonPinned = conversations.indexWhere((c) => !c.isPinned);
      final insertAt =
          firstNonPinned == -1 ? conversations.length : firstNonPinned;
      conversations.insert(insertAt, updated);
    }

    emit(current.copyWith(
      conversations: conversations,
      filtered: _applyFilter(conversations, current.query),
    ));
  }

  // ── Pin / Unpin ────────────────────────────────────────────────────────────

  Future<void> pinConversation(ChatConversation conversation) async {
    final current = state;
    if (current is! ChatLoaded) return;

    final pinned = conversation.copyWith(isPinned: true);
    final updated = current.conversations.toList()
      ..removeWhere((c) => c.id == conversation.id)
      ..insert(0, pinned);
    emit(current.copyWith(
      conversations: updated,
      filtered: _applyFilter(updated, current.query),
    ));

    try {
      await _repo.pinConversation(conversation.otherUser.id);
    } catch (_) {
      await refresh();
    }
  }

  Future<void> unpinConversation(ChatConversation conversation) async {
    final current = state;
    if (current is! ChatLoaded) return;

    final unpinned = conversation.copyWith(isPinned: false);
    final updated = current.conversations
        .map((c) => c.id == conversation.id ? unpinned : c)
        .toList();
    emit(current.copyWith(
      conversations: updated,
      filtered: _applyFilter(updated, current.query),
    ));

    try {
      await _repo.unpinConversation(conversation.otherUser.id);
    } catch (_) {
      await refresh();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<ChatConversation> _filterSelf(List<ChatConversation> conversations) {
    if (_myUserId == null) return conversations;
    final myId = _myUserId.toString();
    return conversations.where((c) => c.otherUser.id != myId).toList();
  }

  List<ChatConversation> _applyFilter(
      List<ChatConversation> conversations, String query) {
    if (query.isEmpty) return conversations;
    final q = query.toLowerCase();
    return conversations.where((c) {
      final name = c.otherUser.name.toLowerCase();
      final id = c.otherUser.studentId?.toLowerCase() ?? '';
      return name.contains(q) || id.contains(q);
    }).toList();
  }

  @override
  Future<void> close() {
    _wsSub?.cancel();
    _searchDebounce?.cancel();
    return super.close();
  }
}
