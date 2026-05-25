part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<ChatConversation> conversations;
  final List<ChatConversation> filtered;
  final String query;
  final bool isSearching;

  /// Results from the backend user-search API (for starting new conversations).
  final List<ChatUser> userSearchResults;
  final bool isLoadingUserSearch;

  const ChatLoaded({
    required this.conversations,
    required this.filtered,
    this.query = '',
    this.isSearching = false,
    this.userSearchResults = const [],
    this.isLoadingUserSearch = false,
  });

  @override
  List<Object?> get props => [
        conversations,
        filtered,
        query,
        isSearching,
        userSearchResults,
        isLoadingUserSearch,
      ];

  ChatLoaded copyWith({
    List<ChatConversation>? conversations,
    List<ChatConversation>? filtered,
    String? query,
    bool? isSearching,
    List<ChatUser>? userSearchResults,
    bool? isLoadingUserSearch,
  }) {
    return ChatLoaded(
      conversations: conversations ?? this.conversations,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      userSearchResults: userSearchResults ?? this.userSearchResults,
      isLoadingUserSearch: isLoadingUserSearch ?? this.isLoadingUserSearch,
    );
  }
}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
