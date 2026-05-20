import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileSectionCard extends StatelessWidget {
  final String? title;
  final IconData? titleIcon;
  final List<Widget> children;

  const ProfileSectionCard({
    super.key,
    this.title,
    this.titleIcon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.xlarge,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) _SectionHeader(title: title!, icon: titleIcon),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm, AppSpacing.xs, AppSpacing.sm, AppSpacing.sm,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const _SectionHeader({required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs,
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
