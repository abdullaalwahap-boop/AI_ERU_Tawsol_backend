import 'package:ai_eru_tawasol/core/services/auth_flow_service.dart';
import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalStorage extends Mock implements LocalStorageService {}

const _normalUser = AuthUserModel(
  userId: 1,
  uniCode: '225040',
  name: 'Ahmed',
  email: 'ahmed@example.com',
  typeCode: 'STU',
  level: 2,
  isTemporaryPassword: false,
);

const _tempUser = AuthUserModel(
  userId: 2,
  uniCode: '225041',
  name: 'New User',
  email: 'new@example.com',
  typeCode: 'STU',
  level: 1,
  isTemporaryPassword: true,
);

void main() {
  late _MockLocalStorage storage;
  late AuthFlowService service;

  setUp(() {
    storage = _MockLocalStorage();
    service = AuthFlowService(storage);
  });

  group('AuthFlowService.resolvePostLoginRoute', () {
    test('returns home when isTemporaryPassword is false', () async {
      final route = await service.resolvePostLoginRoute(_normalUser);
      expect(route, AppRouter.kHomeView);
      verifyNever(() => storage.getPasswordChanged(any()));
    });

    test('returns home when password was already changed locally', () async {
      when(() => storage.getPasswordChanged(_tempUser.userId))
          .thenAnswer((_) async => true);

      final route = await service.resolvePostLoginRoute(_tempUser);

      expect(route, AppRouter.kHomeView);
    });

    test('returns change-password screen on first login with temp password',
        () async {
      when(() => storage.getPasswordChanged(_tempUser.userId))
          .thenAnswer((_) async => false);

      final route = await service.resolvePostLoginRoute(_tempUser);

      expect(route, AppRouter.kFirstLoginChangePasswordView);
    });

    test('markPasswordChanged delegates to storage with correct userId',
        () async {
      when(() => storage.savePasswordChanged(
            userId: any(named: 'userId'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await service.markPasswordChanged(42);

      verify(() => storage.savePasswordChanged(userId: 42, value: true))
          .called(1);
    });
  });
}
