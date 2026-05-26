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
  final List<ChatMessage> filteredMessages;
  final String? sendError;
  final ChatMessage? replyingTo;

  const PrivateChatLoaded({
    required this.messages,
    required this.filteredMessages,
    this.isOtherTyping = false,
    this.isSearching = false,
    this.searchQuery = '',
    this.sendError,
    this.replyingTo,
  });

  List<ChatMessage> get displayMessages =>
      isSearching ? filteredMessages : messages;

  @override
  List<Object?> get props => [
        messages,
        isOtherTyping,
        isSearching,
        searchQuery,
        filteredMessages,
        sendError,
        replyingTo,
      ];

  PrivateChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isOtherTyping,
    bool? isSearching,
    String? searchQuery,
    List<ChatMessage>? filteredMessages,
    String? sendError,
    ChatMessage? replyingTo,
    bool clearReplyingTo = false,
  }) {
    return PrivateChatLoaded(
      messages: messages ?? this.messages,
      isOtherTyping: isOtherTyping ?? this.isOtherTyping,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredMessages: filteredMessages ?? this.filteredMessages,
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
