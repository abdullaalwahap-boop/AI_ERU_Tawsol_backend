import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ChangePasswordInfoBanner extends StatelessWidget {
  const ChangePasswordInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
          AppSpacing.w10,
          Expanded(
            child: Text(
              'Use a strong password with a mix of letters, numbers and symbols.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.info,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
