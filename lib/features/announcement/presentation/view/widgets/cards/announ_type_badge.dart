import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:flutter/material.dart';

class AnnounTypeBadge extends StatelessWidget {
  final AnnouncementType type;

  const AnnounTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: type.lightColor,
        borderRadius: AppRadius.xxlarge,
        border: Border.all(color: type.color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 11, color: type.color),
          AppSpacing.w4,
          Text(
            type.labelOf(context),
            style: AppTextStyles.badgeText.copyWith(
              color: type.color,
            ),
          ),
        ],
      ),
    );
  }
}
