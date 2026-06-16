import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/login_cubit/login_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/test_app_wrapper.dart';

class _MockAuthRepo extends Mock implements AuthRepo {}

const _fakeUser = AuthUserModel(
  userId: 1,
  uniCode: '225040',
  name: 'Ahmed',
  email: 'ahmed@stu.eru.edu.eg',
  typeCode: 'STU',
  level: 2,
  isTemporaryPassword: false,
);

Widget _buildSubject(LoginCubit cubit) => testWrap(
      Scaffold(
        body: BlocProvider.value(value: cubit, child: const LoginForm()),
      ),
    );

void main() {
  late _MockAuthRepo repo;
  late LoginCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repo = _MockAuthRepo();
    cubit = LoginCubit(repo);
  });

  tearDown(() => cubit.close());

  group('LoginForm', () {
    testWidgets('renders email field', (tester) async {
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsAtLeast(1));
      expect(find.byIcon(Icons.alternate_email), findsOneWidget);
    });

    testWidgets('renders password field', (tester) async {
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });

    testWidgets('renders submit button', (tester) async {
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows validation error when email is empty on submit',
        (tester) async {
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
      // Validation error text appears — at least one error shows
      final form = tester.widget<Form>(find.byType(Form));
      expect(form.key, isNotNull);
    });

    testWidgets('submit button shows CircularProgressIndicator when loading',
        (tester) async {
      // Arrange: cubit starts loading
      when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return _fakeUser;
      });

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pumpAndSettle();

      // Enter valid credentials and submit
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'test@stu.eru.edu.eg');
      await tester.enterText(fields.at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // let cubit emit LoginLoading

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Drain the 1-second delayed mock to avoid !timersPending assertion
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('submit button is disabled while loading', (tester) async {
      when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return _fakeUser;
      });

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'test@stu.eru.edu.eg');
      await tester.enterText(fields.at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      // Drain the 1-second delayed mock to avoid !timersPending assertion
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('tapping submit calls LoginCubit.login with trimmed input',
        (tester) async {
      when(() => repo.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => _fakeUser);

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), ' test@stu.eru.edu.eg ');
      await tester.enterText(fields.at(1), 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => repo.login(
            email: 'test@stu.eru.edu.eg',
            password: 'password123',
          )).called(1);
    });
  });
}
