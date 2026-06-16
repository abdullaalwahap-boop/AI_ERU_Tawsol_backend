import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

enum ProfileRole { student, doctor, ta, admin }

extension ProfileRoleExt on ProfileRole {
  String get label {
    switch (this) {
      case ProfileRole.student:
        return 'Student';
      case ProfileRole.doctor:
        return 'Professor';
      case ProfileRole.ta:
        return 'Teaching Assistant';
      case ProfileRole.admin:
        return 'Admin';
    }
  }

  String get shortLabel {
    switch (this) {
      case ProfileRole.student:
        return 'STU';
      case ProfileRole.doctor:
        return 'PROF';
      case ProfileRole.ta:
        return 'T.A';
      case ProfileRole.admin:
        return 'ADM';
    }
  }

  Color get color {
    switch (this) {
      case ProfileRole.student:
        return AppColors.roleStudent;
      case ProfileRole.doctor:
        return AppColors.roleDoctor;
      case ProfileRole.ta:
        return AppColors.contentGreen;
      case ProfileRole.admin:
        return AppColors.roleAdmin;
    }
  }

  Color get lightColor {
    switch (this) {
      case ProfileRole.student:
        return AppColors.roleStudentLight;
      case ProfileRole.doctor:
        return AppColors.roleDoctorLight;
      case ProfileRole.ta:
        return AppColors.contentGreenLight;
      case ProfileRole.admin:
        return AppColors.roleAdminLight;
    }
  }

  IconData get icon {
    switch (this) {
      case ProfileRole.student:
        return Icons.school_rounded;
      case ProfileRole.doctor:
        return Icons.cast_for_education_rounded;
      case ProfileRole.ta:
        return Icons.support_agent_rounded;
      case ProfileRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }
}
