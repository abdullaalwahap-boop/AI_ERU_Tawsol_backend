import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';

extension AnnouncementPriorityUiExt on AnnouncementPriority {
  String get label {
    switch (this) {
      case AnnouncementPriority.normal:
        return 'Normal';
      case AnnouncementPriority.important:
        return 'Important';
      case AnnouncementPriority.urgent:
        return 'Urgent';
    }
  }

  String labelOf(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      AnnouncementPriority.normal => l10n.normal,
      AnnouncementPriority.important => l10n.important,
      AnnouncementPriority.urgent => l10n.urgent,
    };
  }

  Color get color {
    switch (this) {
      case AnnouncementPriority.normal:
        return const Color(0xff3D6FFF);
      case AnnouncementPriority.important:
        return const Color(0xffF59E0B);
      case AnnouncementPriority.urgent:
        return const Color(0xffDC2626);
    }
  }

  Color get lightColor {
    switch (this) {
      case AnnouncementPriority.normal:
        return const Color(0xffEFF6FF);
      case AnnouncementPriority.important:
        return const Color(0xffFEF3C7);
      case AnnouncementPriority.urgent:
        return const Color(0xffFEE2E2);
    }
  }

  IconData get icon {
    switch (this) {
      case AnnouncementPriority.normal:
        return Icons.info_outline_rounded;
      case AnnouncementPriority.important:
        return Icons.star_rounded;
      case AnnouncementPriority.urgent:
        return Icons.priority_high_rounded;
    }
  }
}
