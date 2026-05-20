import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Generic type badge used across announcement, course, and content details.
class ContentTypeBadge extends StatelessWidget {
  const ContentTypeBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.lightColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color lightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.chipPaddingSm,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: AppRadius.circular,
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          AppSpacing.w4,
          Text(
            label,
            style: AppTextStyles.badgeText.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
