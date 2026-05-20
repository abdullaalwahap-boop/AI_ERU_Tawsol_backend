import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/shared/message_status_icon.dart';

class ChatListItemSubtitle extends StatelessWidget {
  final ChatConversation conversation;

  const ChatListItemSubtitle({super.key, required this.conversation});

  String _lastMessagePreview(ChatMessage msg) {
    switch (msg.type) {
      case MessageType.text:
        return msg.text ?? '';
      case MessageType.image:
        return '📷  Photo';
      case MessageType.voice:
        final d = msg.voiceDuration;
        if (d != null) {
          final s = d.inSeconds;
          return '🎤  Voice (${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')})';
        }
        return '🎤  Voice message';
      case MessageType.file:
        return '📎  ${msg.fileName ?? 'Document'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = conversation.otherUser;
    final last = conversation.lastMessage;
    final unread = conversation.unreadCount;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: user.role.lightColor,
            borderRadius: AppRadius.xsmall,
          ),
          child: Text(
            user.role.label,
            style: AppTextStyles.badgeText.copyWith(color: user.role.color),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              if (last != null && last.isFromMe) ...[
                MessageStatusIcon(status: last.status, size: 13),
                const SizedBox(width: 3),
              ],
              Expanded(
                child: Text(
                  last != null ? _lastMessagePreview(last) : 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: unread > 0
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: unread > 0 ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (unread > 0) ...[
          AppSpacing.w8,
          Container(
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              unread > 99 ? '99+' : '$unread',
              style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
