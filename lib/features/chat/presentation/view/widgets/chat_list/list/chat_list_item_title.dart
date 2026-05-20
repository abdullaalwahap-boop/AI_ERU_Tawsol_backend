import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class ChatListItemTitle extends StatelessWidget {
  final ChatConversation conversation;

  const ChatListItemTitle({super.key, required this.conversation});

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}/${dt.year % 100}';
  }

  @override
  Widget build(BuildContext context) {
    final user = conversation.otherUser;
    final last = conversation.lastMessage;
    final unread = conversation.unreadCount;

    return Row(
      children: [
        if (conversation.isPinned) ...[
          const Icon(Icons.push_pin_rounded,
              size: 12, color: AppColors.textHint),
          AppSpacing.w4,
        ],
        Expanded(
          child: Text(
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.w8,
        if (last != null)
          Text(
            _formatTime(last.timestamp),
            style: AppTextStyles.caption.copyWith(
              color: unread > 0 ? AppColors.primary : AppColors.textHint,
              fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
      ],
    );
  }
}
