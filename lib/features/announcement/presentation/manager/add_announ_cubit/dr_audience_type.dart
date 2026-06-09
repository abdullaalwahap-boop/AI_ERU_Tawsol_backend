import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';

enum DrAudienceType { course, specificStudents }

extension DrAudienceTypeExt on DrAudienceType {
  String get label => switch (this) {
        DrAudienceType.course => 'Course\nStudents',
        DrAudienceType.specificStudents => 'Specific\nStudents',
      };

  String labelOf(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      DrAudienceType.course => l10n.courseStudents,
      DrAudienceType.specificStudents => l10n.specificStudents,
    };
  }

  IconData get icon => switch (this) {
        DrAudienceType.course => Icons.groups_rounded,
        DrAudienceType.specificStudents => Icons.person_search_rounded,
      };

  bool get needsRecipientSearch => this == DrAudienceType.specificStudents;
}
