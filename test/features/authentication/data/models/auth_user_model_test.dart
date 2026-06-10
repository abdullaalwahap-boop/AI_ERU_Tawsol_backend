import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fullJson = <String, dynamic>{
    'user_id': 42,
    'uni_code': '225040',
    'name': 'Ahmed Ali',
    'email': 'ahmed@example.com',
    'type_code': 'STU',
    'level': 2,
    'department': 'CS',
    'profile_picture': 'http://example.com/pic.jpg',
    'current_password': false,
  };

  group('AuthUserModel.fromJson', () {
    test('parses all fields correctly', () {
      final user = AuthUserModel.fromJson(fullJson);

      expect(user.userId, 42);
      expect(user.uniCode, '225040');
      expect(user.name, 'Ahmed Ali');
      expect(user.email, 'ahmed@example.com');
      expect(user.typeCode, 'STU');
      expect(user.level, 2);
      expect(user.department, 'CS');
      expect(user.profilePicture, 'http://example.com/pic.jpg');
      expect(user.isTemporaryPassword, false);
    });

    test('defaults level to 0 when absent', () {
      final json = Map<String, dynamic>.from(fullJson)..remove('level');
      expect(AuthUserModel.fromJson(json).level, 0);
    });

    test('defaults isTemporaryPassword to false when absent', () {
      final json = Map<String, dynamic>.from(fullJson)
        ..remove('current_password');
      expect(AuthUserModel.fromJson(json).isTemporaryPassword, false);
    });

    test('maps current_password true → isTemporaryPassword true', () {
      final json = Map<String, dynamic>.from(fullJson)
        ..['current_password'] = true;
      expect(AuthUserModel.fromJson(json).isTemporaryPassword, true);
    });

    test('handles null optional fields', () {
      final json = Map<String, dynamic>.from(fullJson)
        ..['department'] = null
        ..['profile_picture'] = null;
      final user = AuthUserModel.fromJson(json);
      expect(user.department, isNull);
      expect(user.profilePicture, isNull);
    });

    test('parses admin type code correctly', () {
      final json = Map<String, dynamic>.from(fullJson)
        ..['type_code'] = 'ADM'
        ..['level'] = 100;
      final user = AuthUserModel.fromJson(json);
      expect(user.typeCode, 'ADM');
      expect(user.level, 100);
    });
  });

  group('AuthUserModel.copyWith', () {
    final original = AuthUserModel.fromJson(fullJson);

    test('updates name only', () {
      final updated = original.copyWith(name: 'New Name');
      expect(updated.name, 'New Name');
      expect(updated.userId, original.userId);
      expect(updated.email, original.email);
    });

    test('updates profilePicture only', () {
      final updated = original.copyWith(profilePicture: 'new_pic.jpg');
      expect(updated.profilePicture, 'new_pic.jpg');
      expect(updated.name, original.name);
    });

    test('updates isTemporaryPassword only', () {
      final updated = original.copyWith(isTemporaryPassword: true);
      expect(updated.isTemporaryPassword, true);
      expect(updated.name, original.name);
    });

    test('no-arg copyWith preserves all values', () {
      final copy = original.copyWith();
      expect(copy.userId, original.userId);
      expect(copy.name, original.name);
      expect(copy.typeCode, original.typeCode);
      expect(copy.level, original.level);
      expect(copy.department, original.department);
    });
  });
}
