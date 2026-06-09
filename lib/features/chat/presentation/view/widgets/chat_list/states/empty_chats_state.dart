import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class EmptyChatsState extends StatelessWidget {
  const EmptyChatsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: context.colorBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.h24,
            Text(
              'No Conversations Yet',
              style: AppTextStyles.heading3
                  .copyWith(color: context.colorTextPrimary),
            ),
            AppSpacing.h10,
            Text(
              'Start a conversation with your professors,\nteaching assistants, or administrators.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.6,
                color: context.colorTextSecondary,
              ),
            ),
            AppSpacing.h16,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_rounded,
                  size: 14,
                  color: context.colorTextHint,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tap the button below to start',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: context.colorTextHint),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
