import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements SecureStorageService {}

void main() {
  late _MockSecureStorage storage;

  setUp(() => storage = _MockSecureStorage());

  group('SessionCubit', () {
    test('initial state is SessionInitial', () {
      expect(SessionCubit(storage).state, isA<SessionInitial>());
    });

    group('initFromAuth', () {
      blocTest<SessionCubit, SessionState>(
        'emits SessionAuthenticated for student',
        build: () => SessionCubit(storage),
        act: (c) => c.initFromAuth(typeCode: 'STU', userId: 1),
        expect: () => [
          isA<SessionAuthenticated>()
              .having((s) => s.role, 'role', AppRole.student)
              .having((s) => s.userId, 'userId', 1),
        ],
      );

      blocTest<SessionCubit, SessionState>(
        'emits SessionAuthenticated for doctor',
        build: () => SessionCubit(storage),
        act: (c) => c.initFromAuth(typeCode: 'DR', userId: 42),
        expect: () => [
          isA<SessionAuthenticated>()
              .having((s) => s.role, 'role', AppRole.doctor)
              .having((s) => s.userId, 'userId', 42),
        ],
      );

      blocTest<SessionCubit, SessionState>(
        'emits SessionAuthenticated for admin',
        build: () => SessionCubit(storage),
        act: (c) => c.initFromAuth(typeCode: 'ADM', userId: 99),
        expect: () => [
          isA<SessionAuthenticated>()
              .having((s) => s.role, 'role', AppRole.admin),
        ],
      );
    });

    group('clear', () {
      blocTest<SessionCubit, SessionState>(
        'emits SessionUnauthenticated',
        build: () => SessionCubit(storage),
        seed: () => SessionAuthenticated(role: AppRole.student, userId: 1),
        act: (c) => c.clear(),
        expect: () => [isA<SessionUnauthenticated>()],
      );
    });

    group('restoreFromStorage', () {
      blocTest<SessionCubit, SessionState>(
        'emits SessionAuthenticated when storage has valid data',
        build: () {
          when(() => storage.getUserType()).thenAnswer((_) async => 'STU');
          when(() => storage.getUserId()).thenAnswer((_) async => 5);
          return SessionCubit(storage);
        },
        act: (c) => c.restoreFromStorage(),
        expect: () => [
          isA<SessionAuthenticated>()
              .having((s) => s.userId, 'userId', 5)
              .having((s) => s.role, 'role', AppRole.student),
        ],
      );

      blocTest<SessionCubit, SessionState>(
        'emits SessionUnauthenticated when typeCode is null',
        build: () {
          when(() => storage.getUserType()).thenAnswer((_) async => null);
          when(() => storage.getUserId()).thenAnswer((_) async => 5);
          return SessionCubit(storage);
        },
        act: (c) => c.restoreFromStorage(),
        expect: () => [isA<SessionUnauthenticated>()],
      );

      blocTest<SessionCubit, SessionState>(
        'emits SessionUnauthenticated when userId is null',
        build: () {
          when(() => storage.getUserType()).thenAnswer((_) async => 'STU');
          when(() => storage.getUserId()).thenAnswer((_) async => null);
          return SessionCubit(storage);
        },
        act: (c) => c.restoreFromStorage(),
        expect: () => [isA<SessionUnauthenticated>()],
      );
    });
  });
}
