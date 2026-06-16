import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

enum UserRole { student, doctor, ta, admin }

extension UserRoleExt on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.ta:
        return 'Teaching Assistant';
      case UserRole.admin:
        return 'Admin';
    }
  }

  Color get color {
    switch (this) {
      case UserRole.student:
        return AppColors.roleStudent;
      case UserRole.doctor:
        return AppColors.roleDoctor;
      case UserRole.ta:
        return AppColors.contentTeal;
      case UserRole.admin:
        return AppColors.roleAdmin;
    }
  }

  Color get lightColor {
    switch (this) {
      case UserRole.student:
        return AppColors.roleStudentLight;
      case UserRole.doctor:
        return AppColors.roleDoctorLight;
      case UserRole.ta:
        return AppColors.contentTealLight;
      case UserRole.admin:
        return AppColors.roleAdminLight;
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.student:
        return Icons.school_rounded;
      case UserRole.doctor:
        return Icons.menu_book_rounded;
      case UserRole.ta:
        return Icons.assignment_ind_rounded;
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }

  static UserRole fromTypeCode(String typeCode) {
    switch (typeCode.toUpperCase()) {
      case 'DR':
        return UserRole.doctor;
      case 'TA':
        return UserRole.ta;
      case 'ADM':
        return UserRole.admin;
      default:
        return UserRole.student;
    }
  }
}
