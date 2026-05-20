import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:flutter/material.dart';

class ProfileRoleBadge extends StatelessWidget {
  final ProfileRole role;

  const ProfileRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: role.color.withValues(alpha: 0.18),
        borderRadius: AppRadius.circular,
        border: Border.all(
          color: role.color.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(role.icon, size: 13, color: role.color),
          AppSpacing.w4,
          Text(
            role.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: role.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
