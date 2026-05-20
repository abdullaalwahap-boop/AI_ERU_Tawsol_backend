import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_priority_ui_ext.dart';
import 'package:flutter/material.dart';

class AnnounPriorityBadge extends StatelessWidget {
  final AnnouncementPriority priority;

  const AnnounPriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    if (priority == AnnouncementPriority.normal) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: priority.lightColor,
        borderRadius: AppRadius.xxlarge,
        border:
            Border.all(color: priority.color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: 11, color: priority.color),
          AppSpacing.w4,
          Text(
            priority.label,
            style: AppTextStyles.badgeText.copyWith(
              color: priority.color,
            ),
          ),
        ],
      ),
    );
  }
}
