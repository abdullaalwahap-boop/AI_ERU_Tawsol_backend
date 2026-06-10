import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/login_cubit/login_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepo {}

const _normalUser = AuthUserModel(
  userId: 1,
  uniCode: '225040',
  name: 'Ahmed Ali',
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
  late _MockAuthRepo repo;

  setUp(() => repo = _MockAuthRepo());

  group('LoginCubit', () {
    test('initial state is LoginInitial', () {
      expect(LoginCubit(repo).state, isA<LoginInitial>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] on successful login',
      build: () {
        when(
          () => repo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => _normalUser);
        return LoginCubit(repo);
      },
      act: (c) => c.login(email: 'ahmed@example.com', password: 'pass123'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>().having((s) => s.user, 'user', _normalUser),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginPasswordChangeRequired] when isTemporaryPassword',
      build: () {
        when(
          () => repo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => _tempUser);
        return LoginCubit(repo);
      },
      act: (c) => c.login(email: 'new@example.com', password: 'temp123'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginPasswordChangeRequired>()
            .having((s) => s.user.isTemporaryPassword, 'isTemp', true),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginFailure] on exception',
      build: () {
        when(
          () => repo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Invalid credentials'));
        return LoginCubit(repo);
      },
      act: (c) => c.login(email: 'bad@example.com', password: 'wrong'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'LoginFailure contains error message',
      build: () {
        when(
          () => repo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Network error'));
        return LoginCubit(repo);
      },
      act: (c) => c.login(email: 'x@x.com', password: '123456'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.errMessage,
          'errMessage',
          contains('Network error'),
        ),
      ],
    );
  });
}
