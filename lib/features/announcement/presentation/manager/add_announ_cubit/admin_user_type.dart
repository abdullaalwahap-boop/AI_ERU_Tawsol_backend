import 'package:flutter/material.dart';

enum AdminUserType { all, students, doctors }

extension AdminUserTypeExt on AdminUserType {
  String get label {
    switch (this) {
      case AdminUserType.all:
        return 'All';
      case AdminUserType.students:
        return 'Students';
      case AdminUserType.doctors:
        return 'Doctors';
    }
  }

  IconData get icon {
    switch (this) {
      case AdminUserType.all:
        return Icons.groups_rounded;
      case AdminUserType.students:
        return Icons.school_rounded;
      case AdminUserType.doctors:
        return Icons.person_rounded;
    }
  }
}
