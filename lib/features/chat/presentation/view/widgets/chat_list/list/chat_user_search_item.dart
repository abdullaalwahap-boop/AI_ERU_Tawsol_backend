import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_list_item_avatar.dart';

class ChatUserSearchItem extends StatelessWidget {
  final ChatUser user;
  final VoidCallback onTap;

  const ChatUserSearchItem({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.05),
      highlightColor: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ChatListItemAvatar(user: user),
            AppSpacing.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.h2,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: user.role.lightColor,
                          borderRadius: AppRadius.xsmall,
                        ),
                        child: Text(
                          user.role.label,
                          style: AppTextStyles.badgeText
                              .copyWith(color: user.role.color),
                        ),
                      ),
                      if (user.studentId != null) ...[
                        AppSpacing.w6,
                        Text(
                          user.studentId!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 18,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
