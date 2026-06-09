import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/utils/chat_time_formatter.dart';

class ChatListItemTitle extends StatelessWidget {
  final ChatConversation conversation;

  const ChatListItemTitle({super.key, required this.conversation});


  @override
  Widget build(BuildContext context) {
    final user = conversation.otherUser;
    final last = conversation.lastMessage;
    final unread = conversation.unreadCount;

    return Row(
      children: [
        if (conversation.isPinned) ...[
          Icon(Icons.push_pin_rounded,
              size: 12, color: context.colorTextHint),
          AppSpacing.w4,
        ],
        Expanded(
          child: Text(
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600,
              color: context.colorTextPrimary,
            ),
          ),
        ),
        AppSpacing.w8,
        if (last != null)
          Text(
            ChatTimeFormatter.formatConversationTime(last.timestamp),
            style: AppTextStyles.caption.copyWith(
              color: unread > 0 ? AppColors.primary : context.colorTextHint,
              fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
      ],
    );
  }
}
