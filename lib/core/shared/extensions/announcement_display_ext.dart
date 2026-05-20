import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/attachment_file_type_ui_ext.dart';

extension AnnouncementDisplayExt on Announcement {
  ContentDisplayItem toDisplayItem() {
    return ContentDisplayItem(
      id: id,
      title: title,
      body: body,
      authorName: doctorName,
      authorInitials: doctorInitials,
      typeLabel: type.label,
      typeColor: type.color,
      typeLightColor: type.lightColor,
      typeIcon: type.icon,
      formattedDate: formattedDate,
      formattedTime: formattedTime,
      timeAgo: timeAgo,
      contextLabel: subjectName,
      contextCode: subjectCode,
      priorityLabel: _priorityLabel(priority),
      priorityColor: _priorityColor(priority),
      attachments: attachments
          .map(
            (a) => ContentDisplayAttachment(
              name: a.name,
              sizeLabel: '${a.sizeMB.toStringAsFixed(1)} MB',
              icon: a.fileType.icon,
              iconColor: a.fileType.color,
            ),
          )
          .toList(),
      accentColor: AppColors.primary,
      isFromAdmin: isFromAdmin,
    );
  }
}

String? _priorityLabel(AnnouncementPriority priority) {
  switch (priority) {
    case AnnouncementPriority.normal:
      return null;
    case AnnouncementPriority.important:
      return 'Important';
    case AnnouncementPriority.urgent:
      return 'Urgent';
  }
}

Color? _priorityColor(AnnouncementPriority priority) {
  switch (priority) {
    case AnnouncementPriority.normal:
      return null;
    case AnnouncementPriority.important:
      return const Color(0xffF59E0B);
    case AnnouncementPriority.urgent:
      return const Color(0xffEF4444);
  }
}
