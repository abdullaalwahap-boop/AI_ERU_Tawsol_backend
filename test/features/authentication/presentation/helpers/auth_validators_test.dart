import 'package:ai_eru_tawasol/features/authentication/presentation/helpers/auth_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators.email', () {
    test('returns error on null', () {
      expect(AuthValidators.email(null), isNotNull);
    });

    test('returns error on empty string', () {
      expect(AuthValidators.email(''), isNotNull);
    });

    test('returns error on whitespace only', () {
      expect(AuthValidators.email('   '), isNotNull);
    });

    test('returns error when @ is missing', () {
      expect(AuthValidators.email('notanemail'), isNotNull);
    });

    test('returns error when domain is missing', () {
      expect(AuthValidators.email('user@'), isNotNull);
    });

    test('returns error when TLD is missing', () {
      expect(AuthValidators.email('user@domain'), isNotNull);
    });

    test('returns null for valid simple email', () {
      expect(AuthValidators.email('user@example.com'), isNull);
    });

    test('returns null for email with subdomain', () {
      expect(AuthValidators.email('user@mail.example.edu'), isNull);
    });

    test('returns null for email with plus addressing', () {
      expect(AuthValidators.email('user+tag@example.com'), isNull);
    });

    test('returns null for university email format', () {
      expect(AuthValidators.email('225040@student.eelu.edu.eg'), isNull);
    });
  });

  group('AuthValidators.password', () {
    test('returns error on null', () {
      expect(AuthValidators.password(null), isNotNull);
    });

    test('returns error on empty string', () {
      expect(AuthValidators.password(''), isNotNull);
    });

    test('returns error for 5 characters', () {
      expect(AuthValidators.password('12345'), isNotNull);
    });

    test('returns null for exactly 6 characters', () {
      expect(AuthValidators.password('123456'), isNull);
    });

    test('returns null for strong password', () {
      expect(AuthValidators.password('MySecureP@ss1'), isNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    late TextEditingController ctrl;

    setUp(() => ctrl = TextEditingController(text: 'pass1234'));
    tearDown(() => ctrl.dispose());

    test('returns error on null', () {
      expect(AuthValidators.confirmPassword(ctrl)(null), isNotNull);
    });

    test('returns error on empty string', () {
      expect(AuthValidators.confirmPassword(ctrl)(''), isNotNull);
    });

    test('returns error when passwords do not match', () {
      expect(AuthValidators.confirmPassword(ctrl)('different'), isNotNull);
    });

    test('returns null when passwords match exactly', () {
      expect(AuthValidators.confirmPassword(ctrl)('pass1234'), isNull);
    });
  });
}
