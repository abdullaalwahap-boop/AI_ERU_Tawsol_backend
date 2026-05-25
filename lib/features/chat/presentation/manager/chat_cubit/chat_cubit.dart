import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._repo, this._wsService) : super(ChatInitial());

  final ChatRepo _repo;
  final ChatWebSocketService _wsService;

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadConversations() async {
    emit(ChatLoading());
    try {
      await _wsService.ensureConnected();
      final conversations = await _repo.getConversations();
      if (isClosed) return;
      emit(ChatLoaded(conversations: conversations, filtered: conversations));
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
      emit(current.copyWith(
        conversations: conversations,
        filtered: _applyFilter(conversations, current.query),
        userSearchResults: const [],
      ));
    } catch (_) {}
  }

  // ── Conversation filter (client-side) ──────────────────────────────────────

  void toggleSearch() {
    final current = state;
    if (current is! ChatLoaded) return;
    if (current.isSearching) {
      emit(current.copyWith(
        isSearching: false,
        query: '',
        filtered: current.conversations,
        userSearchResults: const [],
      ));
    } else {
      emit(current.copyWith(isSearching: true));
    }
  }

  /// Filters existing conversations client-side AND triggers a backend user
  /// search for new conversation partners when [query] is non-empty.
  void search(String query) {
    final current = state;
    if (current is! ChatLoaded) return;
    emit(current.copyWith(
      query: query,
      filtered: _applyFilter(current.conversations, query),
      userSearchResults: query.isEmpty ? const [] : current.userSearchResults,
    ));
    if (query.isNotEmpty) _searchUsers(query);
  }

  // ── User search (backend) ──────────────────────────────────────────────────

  Future<void> _searchUsers(String q) async {
    final current = state;
    if (current is! ChatLoaded) return;
    emit(current.copyWith(isLoadingUserSearch: true));
    try {
      final results = await _repo.searchUsers(q);
      if (isClosed) return;
      final loaded = state;
      if (loaded is! ChatLoaded || loaded.query != q) return;
      emit(loaded.copyWith(
        userSearchResults: results,
        isLoadingUserSearch: false,
      ));
    } catch (_) {
      if (isClosed) return;
      final loaded = state;
      if (loaded is ChatLoaded) {
        emit(loaded.copyWith(isLoadingUserSearch: false));
      }
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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
}
