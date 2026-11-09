import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/forget_password/forget_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_app_wrapper.dart';

class _MockAuthRepo extends Mock implements AuthRepo {}

Widget _buildSubject(ForgetPasswordCubit cubit) => testWrap(
      Scaffold(
        body: BlocProvider.value(value: cubit, child: const ForgetPasswordForm()),
      ),
    );

void main() {
  late _MockAuthRepo repo;
  late ForgetPasswordCubit cubit;

  setUp(() {
    repo = _MockAuthRepo();
    cubit = ForgetPasswordCubit(repo);
  });

  tearDown(() => cubit.close());

  group('ForgetPasswordForm', () {
    testWidgets('renders email field', (tester) async {
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('renders submit button', (tester) async {
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator inside button when loading',
        (tester) async {
      when(() => repo.forgetPassword(email: any(named: 'email')))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
      });

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField), 'test@suez1.moe.edu.eg');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Drain the 1-second delayed mock to avoid !timersPending assertion
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('submit button is disabled while loading', (tester) async {
      when(() => repo.forgetPassword(email: any(named: 'email')))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
      });

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField), 'test@suez1.moe.edu.eg');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      // Drain the 1-second delayed mock to avoid !timersPending assertion
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('tapping submit with valid email calls forgetPassword',
        (tester) async {
      when(() => repo.forgetPassword(email: any(named: 'email')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      await tester.enterText(
          find.byType(TextFormField), 'test@suez1.moe.edu.eg');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => repo.forgetPassword(email: 'test@suez1.moe.edu.eg')).called(1);
    });
  });
}
