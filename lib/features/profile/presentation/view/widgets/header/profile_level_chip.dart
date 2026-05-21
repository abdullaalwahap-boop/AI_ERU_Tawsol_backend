import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileLevelChip extends StatelessWidget {
  final int level;
  final String department;

  const ProfileLevelChip({
    super.key,
    required this.level,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs + 1,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: AppRadius.circular,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Text(
        'Level $level  ·  $department',
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white.withValues(alpha: 0.88),
        ),
      ),
    );
  }
}
