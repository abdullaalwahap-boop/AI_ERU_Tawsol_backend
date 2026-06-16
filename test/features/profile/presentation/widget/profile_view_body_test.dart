import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/settings/cubit/settings_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/test_app_wrapper.dart';

class _MockProfileRepo extends Mock implements ProfileRepo {}

const _fakeUser = ProfileUser(
  id: '1',
  uniCode: '225040',
  name: 'Ahmed Ali',
  email: 'ahmed@stu.eru.edu.eg',
  role: ProfileRole.student,
  department: 'CS',
  level: 2,
);

Widget _buildSubject(ProfileCubit profileCubit, SettingsCubit settingsCubit) =>
    testWrap(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: profileCubit),
          BlocProvider.value(value: settingsCubit),
        ],
        child: const ProfileViewBody(),
      ),
    );

void main() {
  late _MockProfileRepo repo;
  late ProfileCubit cubit;
  late SettingsCubit settingsCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repo = _MockProfileRepo();
    cubit = ProfileCubit(repo);
    settingsCubit = SettingsCubit(LocalStorageService());
  });

  tearDown(() {
    cubit.close();
    settingsCubit.close();
  });

  group('ProfileViewBody', () {
    testWidgets('shows loading view when state is ProfileInitial',
        (tester) async {
      await tester.pumpWidget(_buildSubject(cubit, settingsCubit));
      await tester.pump();

      expect(find.byType(ProfileViewBody), findsOneWidget);
      expect(find.text('Ahmed Ali'), findsNothing);
    });

    testWidgets('shows loading view when state is ProfileLoading',
        (tester) async {
      cubit.emit(ProfileLoading());

      await tester.pumpWidget(_buildSubject(cubit, settingsCubit));
      await tester.pump();

      expect(find.text('Ahmed Ali'), findsNothing);
    });

    testWidgets('shows error message when state is ProfileError',
        (tester) async {
      cubit.emit(ProfileError('Profile unavailable'));

      await tester.pumpWidget(_buildSubject(cubit, settingsCubit));
      await tester.pump();

      expect(find.text('Profile unavailable'), findsOneWidget);
    });

    testWidgets('shows retry button when state is ProfileError',
        (tester) async {
      when(() => repo.getProfile()).thenAnswer((_) async => _fakeUser);
      cubit.emit(ProfileError('Profile unavailable'));

      await tester.pumpWidget(_buildSubject(cubit, settingsCubit));
      await tester.pump();

      expect(
          find.byType(ElevatedButton).evaluate().isNotEmpty ||
              find.byType(OutlinedButton).evaluate().isNotEmpty ||
              find.byType(TextButton).evaluate().isNotEmpty,
          isTrue);
    });

    testWidgets('shows user name when state is ProfileLoaded', (tester) async {
      cubit.emit(ProfileLoaded(_fakeUser));

      await tester.pumpWidget(_buildSubject(cubit, settingsCubit));
      await tester.pump();

      // Name appears in both header and info section
      expect(find.text('Ahmed Ali'), findsAtLeast(1));
    });
  });
}
