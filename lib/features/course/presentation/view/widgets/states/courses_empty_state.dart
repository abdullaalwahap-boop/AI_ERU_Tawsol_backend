import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:flutter/material.dart';

class CoursesEmptyState extends StatelessWidget {
  const CoursesEmptyState({super.key});

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
                color: AppColors.backgroundLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.h20,
            Text(
              'No Courses Yet',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              'You have no courses assigned this semester.\nCheck back later for updates.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
