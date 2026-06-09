import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_priority_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_subject_avatar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_type_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/meta_row.dart';

String _targetLabel(AppLocalizations l10n, AnnouncementTarget target) =>
    switch (target) {
      AnnouncementTarget.all => l10n.announceToAll,
      AnnouncementTarget.course => l10n.course,
      AnnouncementTarget.courseDepartment => l10n.deptCourse,
      AnnouncementTarget.department => l10n.department,
      AnnouncementTarget.level => l10n.level,
      AnnouncementTarget.student => l10n.student,
      AnnouncementTarget.users => l10n.selectedUsers,
      AnnouncementTarget.role => l10n.role,
    };

class AnnounDetailsHeader extends StatelessWidget {
  final Announcement announcement;

  const AnnounDetailsHeader({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorSurface,
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
                        color: context.colorTextPrimary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.h16,
          Divider(color: context.colorDivider, height: 1),
          AppSpacing.h14,
          MetaRow(
            icon: announcement.isFromAdmin
                ? Icons.admin_panel_settings_rounded
                : Icons.menu_book_rounded,
            label: announcement.isFromAdmin ? l10n.source : l10n.subject,
            value: announcement.isFromAdmin
                ? l10n.admAdministration
                : '${announcement.subjectCode} · ${announcement.subjectName}',
            color: announcement.type.color,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.person_rounded,
            label: l10n.postedBy,
            value: announcement.doctorName,
            color: context.colorTextSecondary,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.calendar_today_rounded,
            label: l10n.date,
            value: announcement.formattedDate,
            color: context.colorTextSecondary,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.access_time_rounded,
            label: l10n.time,
            value: announcement.formattedTime,
            color: context.colorTextSecondary,
          ),
          AppSpacing.h10,
          MetaRow(
            icon: Icons.group_rounded,
            label: l10n.audience,
            value: _targetLabel(l10n, announcement.target),
            color: context.colorTextSecondary,
          ),
        ],
      ),
    );
  }
}
