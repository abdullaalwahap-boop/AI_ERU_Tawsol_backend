import 'package:flutter/material.dart';

enum DrAudienceType { course, specificStudents }

extension DrAudienceTypeExt on DrAudienceType {
  String get label => switch (this) {
        DrAudienceType.course => 'Course\nStudents',
        DrAudienceType.specificStudents => 'Specific\nStudents',
      };

  IconData get icon => switch (this) {
        DrAudienceType.course => Icons.groups_rounded,
        DrAudienceType.specificStudents => Icons.person_search_rounded,
      };

  bool get needsRecipientSearch => this == DrAudienceType.specificStudents;
}
