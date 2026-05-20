import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileLogoutSection extends StatelessWidget {
  const ProfileLogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: Text(
            'Log Out',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.error,
            ),
          ),
          onPressed: () => _confirm(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.35)),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          ),
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _LogoutDialog(),
    );
    if (confirmed != true || !context.mounted) return;
    await LocalStorageService().clearIsLoggedIn();
    if (context.mounted) context.go(AppRouter.kLoginView);
  }
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

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
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.textSecondary,
            ),
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
            style: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
