import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_subject_avatar.dart';

class AnnounCardTopRow extends StatelessWidget {
  final Announcement announcement;

  const AnnounCardTopRow({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnnounSubjectAvatar(announcement: announcement, size: 42),
        AppSpacing.w10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${announcement.subjectCode} · ${announcement.subjectName}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: announcement.type.color,
                  letterSpacing: 0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.h2,
              Text(
                announcement.doctorName,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textHint,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        AppSpacing.w8,
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              announcement.timeAgo,
              style: AppTextStyles.badgeText.copyWith(
                color: AppColors.textHint,
              ),
            ),
            if (!announcement.isRead) ...[
              AppSpacing.h4,
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: announcement.type.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
