import 'package:flutter/material.dart';

import 'package:ai_eru_tawasol/core/shared/models/content_display_attachment.dart';
export 'package:ai_eru_tawasol/core/shared/models/content_display_attachment.dart';

class ContentDisplayItem {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final String authorInitials;
  final String typeLabel;
  final Color typeColor;
  final Color typeLightColor;
  final IconData typeIcon;
  final String formattedDate;
  final String formattedTime;
  final String timeAgo;
  final String? contextLabel;
  final String? contextCode;
  final String? priorityLabel;
  final Color? priorityColor;
  final List<ContentDisplayAttachment> attachments;
  final Color accentColor;
  final bool isFromAdmin;
  final DateTime? deadline;

  const ContentDisplayItem({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.authorInitials,
    required this.typeLabel,
    required this.typeColor,
    required this.typeLightColor,
    required this.typeIcon,
    required this.formattedDate,
    required this.formattedTime,
    required this.timeAgo,
    this.contextLabel,
    this.contextCode,
    this.priorityLabel,
    this.priorityColor,
    this.attachments = const [],
    required this.accentColor,
    this.isFromAdmin = false,
    this.deadline,
  });
}
