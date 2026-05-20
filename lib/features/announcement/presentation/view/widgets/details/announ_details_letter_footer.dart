import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';

class AnnounDetailsLetterFooter extends StatelessWidget {
  final Announcement announcement;

  const AnnounDetailsLetterFooter({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: announcement.type.lightColor,
              borderRadius: AppRadius.small,
            ),
            child: Center(
              child: Text(
                announcement.doctorInitials,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: announcement.type.color,
                ),
              ),
            ),
          ),
          AppSpacing.w10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.doctorName,
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${announcement.subjectName} · ${announcement.formattedDate}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
