import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_priority_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_subject_avatar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_type_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/meta_row.dart';

class AnnounDetailsHeader extends StatelessWidget {
  final Announcement announcement;

  const AnnounDetailsHeader({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnnounSubjectAvatar(announcement: announcement, size: 52),
              AppSpacing.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnnounTypeBadge(type: announcement.type),
                        AppSpacing.w6,
                        AnnounPriorityBadge(priority: announcement.priority),
                      ],
                    ),
                    AppSpacing.h8,
                    Text(
                      announcement.title,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.h16,
          const Divider(color: AppColors.dividerLight, height: 1),
          AppSpacing.h14,
          MetaRow(
            icon: Icons.menu_book_rounded,
            label: 'Subject',
            value: '${announcement.subjectCode} · ${announcement.subjectName}',
            color: announcement.type.color,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.person_rounded,
            label: 'Posted by',
            value: announcement.doctorName,
            color: AppColors.textSecondary,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: announcement.formattedDate,
            color: AppColors.textSecondary,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: announcement.formattedTime,
            color: AppColors.textSecondary,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.group_rounded,
            label: 'Audience',
            value: announcement.target.label,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
