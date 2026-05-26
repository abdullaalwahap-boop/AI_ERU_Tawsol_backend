import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/date_separator.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/message_bubble.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/typing_indicator.dart';

/// Reversed list — index 0 sits at the visual bottom.
/// Messages are passed in chronological order (oldest first); we reverse
/// internally so the newest message is always pinned at the bottom without
/// any programmatic scroll.
class ChatMessageList extends StatelessWidget {
  final ScrollController scrollController;
  final List<ChatMessage> messages;
  final bool isSearching;
  final bool isOtherTyping;
  final String searchQuery;

  /// IDs of messages that match the current search query (empty when not searching).
  final Set<String> searchMatchIds;

  final ChatUser otherUser;
  final void Function(String messageId)? onScrollToMessage;
  final ValueNotifier<String?> highlightedId;

  const ChatMessageList({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isSearching,
    required this.isOtherTyping,
    required this.searchQuery,
    required this.otherUser,
    required this.highlightedId,
    this.searchMatchIds = const <String>{},
    this.onScrollToMessage,
  });

  Map<String, ChatMessage> _buildIndex(List<ChatMessage> msgs) {
    return {for (final m in msgs) m.id: m};
  }

  bool _showDateSeparator(List<ChatMessage> reversed, int index) {
    if (index == reversed.length - 1) return true;
    final curr = reversed[index].timestamp;
    final older = reversed[index + 1].timestamp;
    return curr.year != older.year ||
        curr.month != older.month ||
        curr.day != older.day;
  }

  @override
  Widget build(BuildContext context) {
    // Show no-results state only when actively searching with a non-empty query
    // that yields no matches.
    if (isSearching && searchQuery.isNotEmpty && searchMatchIds.isEmpty) {
      return _NoResults(query: searchQuery);
    }

    final reversed = messages.reversed.toList();
    final index = _buildIndex(messages);
    final hasTyping = !isSearching && isOtherTyping;
    final itemCount = reversed.length + (hasTyping ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (hasTyping && i == 0) {
          return TypingIndicator(user: otherUser);
        }
        final msgIndex = hasTyping ? i - 1 : i;
        final message = reversed[msgIndex];
        final replyToMessage =
            message.replyToId != null ? index[message.replyToId] : null;

        return Column(
          children: [
            if (_showDateSeparator(reversed, msgIndex))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DateSeparator(date: message.timestamp),
              ),
            MessageBubble(
              key: GlobalObjectKey(message.id),
              message: message,
              replyToMessage: replyToMessage,
              otherUserName: otherUser.name,
              highlightedId: highlightedId,
              isSearchMatch: searchMatchIds.contains(message.id),
              onScrollToMessage: onScrollToMessage,
            ),
          ],
        );
      },
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;

  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xffA0AABB),
          ),
          AppSpacing.h12,
          Text(
            'No messages found for "$query"',
            style: const TextStyle(color: Color(0xff64748B), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
