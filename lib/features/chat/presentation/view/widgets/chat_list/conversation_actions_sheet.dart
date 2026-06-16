import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class ConversationActionsSheet extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onPin;
  final VoidCallback onUnpin;

  const ConversationActionsSheet({
    super.key,
    required this.conversation,
    required this.onPin,
    required this.onUnpin,
  });

  @override
  Widget build(BuildContext context) {
    final isPinned = conversation.isPinned;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: AppRadius.large,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: context.colorDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: conversation.otherUser.role.lightColor,
                  child: Text(
                    conversation.otherUser.initials,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: conversation.otherUser.role.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppSpacing.w12,
                Expanded(
                  child: Text(
                    conversation.otherUser.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: context.colorTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.colorDivider),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              isPinned ? onUnpin() : onPin();
            },
            borderRadius: AppRadius.medium,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isPinned
                          ? Icons.push_pin_outlined
                          : Icons.push_pin_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  AppSpacing.w12,
                  Text(
                    isPinned ? 'Unpin conversation' : 'Pin conversation',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
