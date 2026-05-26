part of 'private_chat_cubit.dart';

sealed class PrivateChatState extends Equatable {
  const PrivateChatState();

  @override
  List<Object?> get props => [];
}

final class PrivateChatInitial extends PrivateChatState {}

final class PrivateChatLoading extends PrivateChatState {}

final class PrivateChatLoaded extends PrivateChatState {
  final List<ChatMessage> messages;
  final bool isOtherTyping;
  final bool isSearching;
  final String searchQuery;

  /// IDs of messages that match the current query, in chronological order.
  final List<String> searchResults;

  /// Index into [searchResults] for the currently focused result.
  /// 0 = oldest match, length-1 = newest match.
  final int searchResultIndex;

  final String? sendError;
  final ChatMessage? replyingTo;

  const PrivateChatLoaded({
    required this.messages,
    this.isOtherTyping = false,
    this.isSearching = false,
    this.searchQuery = '',
    this.searchResults = const <String>[],
    this.searchResultIndex = 0,
    this.sendError,
    this.replyingTo,
  });

  /// Always the full message list — search is shown as an overlay, not a filter.
  List<ChatMessage> get displayMessages => messages;

  /// The message ID of the currently focused search result, or null.
  String? get currentResultId =>
      searchResults.isEmpty ? null : searchResults[searchResultIndex];

  @override
  List<Object?> get props => [
        messages,
        isOtherTyping,
        isSearching,
        searchQuery,
        searchResults,
        searchResultIndex,
        sendError,
        replyingTo,
      ];

  PrivateChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isOtherTyping,
    bool? isSearching,
    String? searchQuery,
    List<String>? searchResults,
    int? searchResultIndex,
    String? sendError,
    ChatMessage? replyingTo,
    bool clearReplyingTo = false,
  }) {
    return PrivateChatLoaded(
      messages: messages ?? this.messages,
      isOtherTyping: isOtherTyping ?? this.isOtherTyping,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      searchResultIndex: searchResultIndex ?? this.searchResultIndex,
      sendError: sendError,
      replyingTo: clearReplyingTo ? null : (replyingTo ?? this.replyingTo),
    );
  }
}

final class PrivateChatError extends PrivateChatState {
  final String message;

  const PrivateChatError(this.message);

  @override
  List<Object?> get props => [message];
}
