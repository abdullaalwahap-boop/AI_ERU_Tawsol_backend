import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const ProfileSectionHeader({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.circular,
            ),
          ),
          AppSpacing.w8,
          if (icon != null) ...[
            Icon(icon, size: 13, color: AppColors.primary),
            AppSpacing.w4,
          ],
          Text(
            title.toUpperCase(),
            style: AppTextStyles.overline.copyWith(
              color: AppColors.primary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
