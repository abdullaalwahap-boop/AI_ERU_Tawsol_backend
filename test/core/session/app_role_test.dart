import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRole.fromTypeCode', () {
    test('DR → doctor', () {
      expect(AppRole.fromTypeCode('DR'), AppRole.doctor);
    });
    test('TA → ta', () {
      expect(AppRole.fromTypeCode('TA'), AppRole.ta);
    });
    test('ADM → admin', () {
      expect(AppRole.fromTypeCode('ADM'), AppRole.admin);
    });
    test('STU → student', () {
      expect(AppRole.fromTypeCode('STU'), AppRole.student);
    });
    test('unknown → student (default)', () {
      expect(AppRole.fromTypeCode('XYZ'), AppRole.student);
    });
    test('lowercase handled via toUpperCase', () {
      expect(AppRole.fromTypeCode('dr'), AppRole.doctor);
      expect(AppRole.fromTypeCode('adm'), AppRole.admin);
    });
  });

  group('AppRole permission guards', () {
    test('student cannot post announcements', () {
      expect(AppRole.student.canPostAnnouncements, false);
    });
    test('doctor can post announcements', () {
      expect(AppRole.doctor.canPostAnnouncements, true);
    });
    test('ta can post announcements', () {
      expect(AppRole.ta.canPostAnnouncements, true);
    });
    test('admin can post announcements', () {
      expect(AppRole.admin.canPostAnnouncements, true);
    });

    test('only admin isAdmin', () {
      expect(AppRole.admin.isAdmin, true);
      expect(AppRole.doctor.isAdmin, false);
      expect(AppRole.student.isAdmin, false);
      expect(AppRole.ta.isAdmin, false);
    });

    test('admin has no bottom nav', () {
      expect(AppRole.admin.hasBottomNav, false);
    });
    test('student/doctor/ta have bottom nav', () {
      expect(AppRole.student.hasBottomNav, true);
      expect(AppRole.doctor.hasBottomNav, true);
      expect(AppRole.ta.hasBottomNav, true);
    });
  });

  group('AppRole feature adapters', () {
    test('student → AnnounRole.student', () {
      expect(AppRole.student.toAnnounRole, AnnounRole.student);
    });
    test('doctor → AnnounRole.doctor', () {
      expect(AppRole.doctor.toAnnounRole, AnnounRole.doctor);
    });
    test('ta → AnnounRole.doctor (TA follows doctor flow)', () {
      expect(AppRole.ta.toAnnounRole, AnnounRole.doctor);
    });
    test('admin → AnnounRole.admin', () {
      expect(AppRole.admin.toAnnounRole, AnnounRole.admin);
    });

    test('student → CourseRole.student', () {
      expect(AppRole.student.toCourseRole, CourseRole.student);
    });
    test('doctor → CourseRole.doctor', () {
      expect(AppRole.doctor.toCourseRole, CourseRole.doctor);
    });

    test('student → ProfileRole.student', () {
      expect(AppRole.student.toProfileRole, ProfileRole.student);
    });
    test('doctor → ProfileRole.doctor', () {
      expect(AppRole.doctor.toProfileRole, ProfileRole.doctor);
    });
    test('ta → ProfileRole.ta', () {
      expect(AppRole.ta.toProfileRole, ProfileRole.ta);
    });
    test('admin → ProfileRole.admin', () {
      expect(AppRole.admin.toProfileRole, ProfileRole.admin);
    });
  });
}
