import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:flutter/material.dart';

class AnnounDetailsLetterHeaderStrip extends StatelessWidget {
  final Announcement announcement;

  const AnnounDetailsLetterHeaderStrip({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            announcement.type.color.withValues(alpha: 0.08),
            announcement.type.color.withValues(alpha: 0.03),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: announcement.type.lightColor,
              borderRadius: AppRadius.small,
            ),
            child: Icon(announcement.type.icon,
                size: 18, color: announcement.type.color),
          ),
          AppSpacing.w10,
          Text(
            AppLocalizations.of(context).message,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: announcement.type.color,
            ),
          ),
        ],
      ),
    );
  }
}
