import 'package:flutter/material.dart';

enum AdminUserType { all, students, doctors, ta, specificUsers }

extension AdminUserTypeExt on AdminUserType {
  String get label => switch (this) {
        AdminUserType.all => 'All',
        AdminUserType.students => 'Students',
        AdminUserType.doctors => 'Doctors',
        AdminUserType.ta => 'Assistants',
        AdminUserType.specificUsers => 'Specific Users',
      };

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
        AdminUserType.students => 'level',
        AdminUserType.doctors => 'department',
        AdminUserType.ta => 'department',
        AdminUserType.specificUsers => 'users',
      };

  /// The backend role filter string (for /announcements/recipients endpoint).
  String? get roleFilter => switch (this) {
        AdminUserType.doctors => 'DR',
        AdminUserType.ta => 'TA',
        AdminUserType.students => 'STU',
        _ => null,
      };

  bool get needsDepartment =>
      this == AdminUserType.doctors ||
      this == AdminUserType.ta ||
      this == AdminUserType.students;

  bool get needsYear => this == AdminUserType.students;

  bool get needsRecipientSearch => this == AdminUserType.specificUsers;
}
