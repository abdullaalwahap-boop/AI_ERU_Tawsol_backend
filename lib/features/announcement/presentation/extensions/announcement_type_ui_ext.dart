import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';

extension AnnouncementTypeUiExt on AnnouncementType {
  String get label {
    switch (this) {
      case AnnouncementType.normal:
        return 'Announcement';
      case AnnouncementType.materialFile:
        return 'Material';
      case AnnouncementType.assignment:
        return 'Assignment';
    }
  }

  String labelOf(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      AnnouncementType.normal => l10n.announcementLabel,
      AnnouncementType.materialFile => l10n.material,
      AnnouncementType.assignment => l10n.assignment,
    };
  }

  Color get color {
    switch (this) {
      case AnnouncementType.normal:
        return const Color(0xff3D6FFF);
      case AnnouncementType.materialFile:
        return const Color(0xff059669);
      case AnnouncementType.assignment:
        return const Color(0xff7C3AED);
    }
  }

  Color get lightColor {
    switch (this) {
      case AnnouncementType.normal:
        return const Color(0xffEFF6FF);
      case AnnouncementType.materialFile:
        return const Color(0xffD1FAE5);
      case AnnouncementType.assignment:
        return const Color(0xffEDE9FE);
    }
  }

  IconData get icon {
    switch (this) {
      case AnnouncementType.normal:
        return Icons.campaign_rounded;
      case AnnouncementType.materialFile:
        return Icons.menu_book_rounded;
      case AnnouncementType.assignment:
        return Icons.assignment_rounded;
    }
  }
}
