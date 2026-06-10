import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── ProfileRole labels ───────────────────────────────────────────────────

  group('ProfileRole.label', () {
    test('student returns Student', () {
      expect(ProfileRole.student.label, 'Student');
    });
    test('doctor returns Professor', () {
      expect(ProfileRole.doctor.label, 'Professor');
    });
    test('ta returns Teaching Assistant', () {
      expect(ProfileRole.ta.label, 'Teaching Assistant');
    });
    test('admin returns Admin', () {
      expect(ProfileRole.admin.label, 'Admin');
    });
  });

  group('ProfileRole.shortLabel', () {
    test('student short label is STU', () {
      expect(ProfileRole.student.shortLabel, 'STU');
    });
    test('doctor short label is PROF', () {
      expect(ProfileRole.doctor.shortLabel, 'PROF');
    });
    test('ta short label is T.A', () {
      expect(ProfileRole.ta.shortLabel, 'T.A');
    });
    test('admin short label is ADM', () {
      expect(ProfileRole.admin.shortLabel, 'ADM');
    });
  });

  // ── ProfileUser ──────────────────────────────────────────────────────────

  const baseUser = ProfileUser(
    id: '42',
    uniCode: '225040',
    name: 'Ali Hassan',
    email: 'ali@uni.edu',
    role: ProfileRole.student,
    department: 'CS',
    level: 2,
  );

  group('ProfileUser.copyWith', () {
    test('returns identical object when no args provided', () {
      final copy = baseUser.copyWith();
      expect(copy.id, baseUser.id);
      expect(copy.name, baseUser.name);
      expect(copy.email, baseUser.email);
      expect(copy.role, baseUser.role);
      expect(copy.department, baseUser.department);
      expect(copy.level, baseUser.level);
      expect(copy.avatarUrl, isNull);
    });

    test('updates name without touching other fields', () {
      final copy = baseUser.copyWith(name: 'Mohamed Ali');
      expect(copy.name, 'Mohamed Ali');
      expect(copy.id, baseUser.id);
      expect(copy.email, baseUser.email);
      expect(copy.role, baseUser.role);
    });

    test('updates avatarUrl without touching other fields', () {
      final copy = baseUser.copyWith(avatarUrl: 'https://cdn.uni.edu/avatar.png');
      expect(copy.avatarUrl, 'https://cdn.uni.edu/avatar.png');
      expect(copy.name, baseUser.name);
    });

    test('updates both name and avatarUrl simultaneously', () {
      final copy = baseUser.copyWith(
        name: 'New Name',
        avatarUrl: 'https://cdn.uni.edu/new.png',
      );
      expect(copy.name, 'New Name');
      expect(copy.avatarUrl, 'https://cdn.uni.edu/new.png');
    });

    test('preserves null avatarUrl when not specified', () {
      final user = const ProfileUser(
        id: '1',
        uniCode: 'U001',
        name: 'Test',
        email: 'test@uni.edu',
        role: ProfileRole.doctor,
        department: 'EE',
        avatarUrl: null,
      );
      final copy = user.copyWith(name: 'Updated');
      expect(copy.avatarUrl, isNull);
    });

    test('does not change email, id, role, department, or level', () {
      final copy = baseUser.copyWith(name: 'X', avatarUrl: 'Y');
      expect(copy.email, baseUser.email);
      expect(copy.id, baseUser.id);
      expect(copy.role, baseUser.role);
      expect(copy.department, baseUser.department);
      expect(copy.level, baseUser.level);
    });
  });

  group('ProfileUser fields', () {
    test('level can be null', () {
      const noLevel = ProfileUser(
        id: '5',
        uniCode: 'ADM001',
        name: 'Admin User',
        email: 'admin@uni.edu',
        role: ProfileRole.admin,
        department: 'IT',
      );
      expect(noLevel.level, isNull);
    });

    test('stores all roles correctly', () {
      for (final role in ProfileRole.values) {
        final user = ProfileUser(
          id: '1',
          uniCode: 'X',
          name: 'X',
          email: 'x@x.com',
          role: role,
          department: 'X',
        );
        expect(user.role, role);
      }
    });
  });
}
