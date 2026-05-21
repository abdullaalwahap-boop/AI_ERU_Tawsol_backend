import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileLogoutDialog extends StatelessWidget {
  const ProfileLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlarge),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: AppRadius.medium,
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 20,
            ),
          ),
          AppSpacing.w12,
          Text(
            'Log Out',
            style:
                AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to log out of your ERU account?',
        style:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonSmall
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            elevation: 0,
          ),
          child: Text(
            'Log Out',
            style: AppTextStyles.buttonSmall
                .copyWith(color: AppColors.textOnPrimary),
          ),
        ),
      ],
    );
  }
}
