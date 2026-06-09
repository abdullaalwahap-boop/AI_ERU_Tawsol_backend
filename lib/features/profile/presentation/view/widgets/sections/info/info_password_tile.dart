import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfilePasswordTile extends StatelessWidget {
  final bool showPassword;
  final VoidCallback onToggle;
  final VoidCallback onChangePassword;

  const ProfilePasswordTile({
    super.key,
    required this.showPassword,
    required this.onToggle,
    required this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.09),
              borderRadius: AppRadius.medium,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: AppTextStyles.caption
                      .copyWith(color: context.colorTextSecondary),
                ),
                Row(
                  children: [
                    Text(
                      showPassword ? 'mypassword' : '••••••••••',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: context.colorTextPrimary,
                        letterSpacing: showPassword ? 0 : 2.5,
                      ),
                    ),
                    AppSpacing.w8,
                    GestureDetector(
                      onTap: onToggle,
                      child: Icon(
                        showPassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 16,
                        color: context.colorTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChangePassword,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Change',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
