import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';

/// Canonical role enum for the entire application.
///
/// Backend maps type_code → role:
///   "STU" → student | "DR" → doctor | "TA" → ta | "ADM" → admin
enum AppRole {
  student,
  doctor,
  ta,
  admin;

  factory AppRole.fromTypeCode(String typeCode) {
    switch (typeCode.toUpperCase()) {
      case 'DR':
        return AppRole.doctor;
      case 'TA':
        return AppRole.ta;
      case 'ADM':
        return AppRole.admin;
      default:
        return AppRole.student;
    }
  }

  // ── Permission guards ─────────────────────────────────────────────────────

  bool get canPostAnnouncements =>
      this == doctor || this == ta || this == admin;

  bool get isAdmin => this == admin;

  bool get hasBottomNav => this != admin;

  // ── Feature adapters ──────────────────────────────────────────────────────

  /// TA follows the Doctor flow for announcements (can create and manage).
  AnnounRole get toAnnounRole {
    switch (this) {
      case student:
        return AnnounRole.student;
      case doctor:
      case ta:
        return AnnounRole.doctor;
      case admin:
        return AnnounRole.admin;
    }
  }

  CourseRole get toCourseRole =>
      this == student ? CourseRole.student : CourseRole.doctor;

  ProfileRole get toProfileRole {
    switch (this) {
      case student:
        return ProfileRole.student;
      case doctor:
        return ProfileRole.doctor;
      case ta:
        return ProfileRole.ta;
      case admin:
        return ProfileRole.admin;
    }
  }
}
