import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

extension ContentTypeUiExt on ContentType {
  String get label {
    switch (this) {
      case ContentType.announcement:
        return 'Announcement';
      case ContentType.material:
        return 'Material';
      case ContentType.assignment:
        return 'Assignment';
    }
  }

  String labelOf(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      ContentType.announcement => l10n.announcementLabel,
      ContentType.material => l10n.material,
      ContentType.assignment => l10n.assignment,
    };
  }

  Color get color {
    switch (this) {
      case ContentType.announcement:
        return const Color(0xff3D6FFF);
      case ContentType.material:
        return const Color(0xff059669);
      case ContentType.assignment:
        return const Color(0xff7C3AED);
    }
  }

  Color get lightColor {
    switch (this) {
      case ContentType.announcement:
        return const Color(0xffEFF6FF);
      case ContentType.material:
        return const Color(0xffD1FAE5);
      case ContentType.assignment:
        return const Color(0xffEDE9FE);
    }
  }

  IconData get icon {
    switch (this) {
      case ContentType.announcement:
        return Icons.campaign_rounded;
      case ContentType.material:
        return Icons.menu_book_rounded;
      case ContentType.assignment:
        return Icons.assignment_rounded;
    }
  }
}
