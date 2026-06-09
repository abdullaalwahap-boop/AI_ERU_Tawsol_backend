import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_mode.dart';
import 'package:flutter/material.dart';

class ChangePasswordInfoBanner extends StatelessWidget {
  final ChangePasswordMode mode;

  const ChangePasswordInfoBanner({
    super.key,
    this.mode = ChangePasswordMode.profile,
  });

  @override
  Widget build(BuildContext context) {
    final isFirstLogin = mode == ChangePasswordMode.firstLogin;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isFirstLogin ? context.colorBackground : AppColors.infoLight,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: isFirstLogin
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.info.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isFirstLogin
                ? Icons.lock_outline_rounded
                : Icons.info_outline_rounded,
            color: isFirstLogin ? AppColors.primary : AppColors.info,
            size: 18,
          ),
          AppSpacing.w10,
          Expanded(
            child: Text(
              isFirstLogin
                  ? 'Your account was created with a temporary password. Please set a secure personal password to continue.'
                  : 'Use a strong password with a mix of letters, numbers and symbols.',
              style: AppTextStyles.bodySmall.copyWith(
                color: isFirstLogin ? AppColors.primary : AppColors.info,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
