import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';

enum AdminUserType { all, students, doctors, ta, specificUsers }

extension AdminUserTypeExt on AdminUserType {
  String get label => switch (this) {
        AdminUserType.all => 'All',
        AdminUserType.students => 'Students',
        AdminUserType.doctors => 'Doctors',
        AdminUserType.ta => 'Assistants',
        AdminUserType.specificUsers => 'Specific Users',
      };

  String labelOf(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      AdminUserType.all => l10n.all,
      AdminUserType.students => l10n.students,
      AdminUserType.doctors => l10n.doctors,
      AdminUserType.ta => l10n.assistants,
      AdminUserType.specificUsers => l10n.specificUsers,
    };
  }

  IconData get icon => switch (this) {
        AdminUserType.all => Icons.groups_rounded,
        AdminUserType.students => Icons.school_rounded,
        AdminUserType.doctors => Icons.person_rounded,
        AdminUserType.ta => Icons.co_present_rounded,
        AdminUserType.specificUsers => Icons.person_search_rounded,
      };

  /// Maps to the backend `target_type` value.
  String get targetType => switch (this) {
        AdminUserType.all => 'all',
        AdminUserType.students => 'role',
        AdminUserType.doctors => 'role',
        AdminUserType.ta => 'role',
        AdminUserType.specificUsers => 'users',
      };

  /// The backend role value sent when target_type="role".
  String? get targetRole => switch (this) {
        AdminUserType.doctors => 'DR',
        AdminUserType.ta => 'TA',
        AdminUserType.students => 'STU',
        _ => null,
      };

  /// The backend role filter string for /announcements/recipients endpoint.
  /// specificUsers searches all roles (null = no filter).
  String? get roleFilter => switch (this) {
        AdminUserType.doctors => 'DR',
        AdminUserType.ta => 'TA',
        AdminUserType.students => 'STU',
        _ => null, // specificUsers and all → no role filter
      };

  /// Whether this type shows the department/level filter section.
  bool get hasStudentFilter => this == AdminUserType.students;

  bool get needsRecipientSearch => this == AdminUserType.specificUsers;
}
