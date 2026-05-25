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
  final ChatUser otherUser;

  const ChatMessageList({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isSearching,
    required this.isOtherTyping,
    required this.searchQuery,
    required this.otherUser,
  });

  // In the reversed array, index+1 is the OLDER neighbour.
  // Show a separator before a message when the older neighbour is a different day,
  // or when this is the very oldest message in the list.
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
    if (messages.isEmpty && isSearching) {
      return _NoResults(query: searchQuery);
    }

    final reversed = messages.reversed.toList();
    final hasTyping = !isSearching && isOtherTyping;
    final itemCount = reversed.length + (hasTyping ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Typing indicator occupies index 0 — the visual bottom slot.
        if (hasTyping && index == 0) {
          return TypingIndicator(user: otherUser);
        }
        final msgIndex = hasTyping ? index - 1 : index;
        final message = reversed[msgIndex];
        return Column(
          children: [
            if (_showDateSeparator(reversed, msgIndex))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DateSeparator(date: message.timestamp),
              ),
            MessageBubble(message: message),
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
