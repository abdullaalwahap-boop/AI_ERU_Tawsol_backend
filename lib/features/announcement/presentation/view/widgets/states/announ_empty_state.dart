import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class AnnounEmptyState extends StatelessWidget {
  const AnnounEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: context.colorBackground,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    width: 2),
              ),
              child: const Icon(Icons.campaign_outlined,
                  size: 40, color: AppColors.primary),
            ),
            AppSpacing.h20,
            Text(
              'No Announcements Yet',
              style: AppTextStyles.titleMedium.copyWith(
                color: context.colorTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              'There are no announcements at the moment.\nCheck back later for updates.',
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colorTextSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
