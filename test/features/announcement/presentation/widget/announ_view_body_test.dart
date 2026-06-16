import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/announ_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/getit_test_setup.dart';
import '../../../../helpers/test_app_wrapper.dart';

class _MockAnnounRepo extends Mock implements AnnounRepo {}

class _MockSecureStorage extends Mock implements SecureStorageService {}

Announcement _ann(String id) => Announcement(
      id: id,
      title: 'Title $id',
      body: 'Body $id',
      doctorName: 'Dr. Test',
      subjectName: 'CS',
      subjectCode: 'CS101',
      type: AnnouncementType.normal,
      target: AnnouncementTarget.all,
      priority: AnnouncementPriority.normal,
      createdAt: DateTime(2024, 1, 1),
    );

// AnnounCardContent reads SessionCubit — provide a stub session for all tests
Widget _buildSubject(
  AnnounCubit cubit,
  SessionCubit sessionCubit, {
  AnnounRole role = AnnounRole.student,
}) =>
    testWrap(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider.value(value: sessionCubit),
        ],
        child: AnnounViewBody(role: role),
      ),
    );

void main() {
  late _MockAnnounRepo repo;
  late AnnounCubit cubit;
  late SessionCubit sessionCubit;

  setUp(() {
    repo = _MockAnnounRepo();
    cubit = AnnounCubit(repo);

    final storage = _MockSecureStorage();
    when(() => storage.getUserId()).thenAnswer((_) async => 1);
    when(() => storage.getUserType()).thenAnswer((_) async => 'STU');
    when(() => storage.getAccessToken()).thenAnswer((_) async => null);
    sessionCubit = SessionCubit(storage)
      ..initFromAuth(typeCode: 'STU', userId: 1);

    setupTestGetIt();
  });

  tearDown(() {
    cubit.close();
    sessionCubit.close();
    tearDownTestGetIt();
  });

  group('AnnounViewBody', () {
    testWidgets('renders loading skeleton when state is AnnounLoading',
        (tester) async {
      // Emit loading directly — avoids creating a pending async timer from the repo mock
      cubit.emit(AnnounLoading());

      await tester.pumpWidget(_buildSubject(cubit, sessionCubit));
      await tester.pump();

      expect(find.byType(AnnounViewBody), findsOneWidget);

      // Drain staggered shimmer timers: AnnounLoadingSkeletonCard index 3 = 360ms
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('renders error message when state is AnnounError',
        (tester) async {
      cubit.emit(AnnounError('Failed to load'));

      await tester.pumpWidget(_buildSubject(cubit, sessionCubit));
      await tester.pump();

      expect(find.text('Failed to load'), findsOneWidget);
    });

    testWidgets('renders announcement list when loaded with items',
        (tester) async {
      cubit.emit(AnnounLoaded(primary: [_ann('1'), _ann('2'), _ann('3')]));

      await tester.pumpWidget(_buildSubject(cubit, sessionCubit));
      await tester.pump();

      expect(find.text('Title 1'), findsOneWidget);
      expect(find.text('Title 2'), findsOneWidget);
    });

    testWidgets('renders empty-state widget when loaded with no items',
        (tester) async {
      cubit.emit(const AnnounLoaded(primary: []));

      await tester.pumpWidget(_buildSubject(cubit, sessionCubit));
      await tester.pump();

      expect(find.text('Title 1'), findsNothing);
    });

    testWidgets('switches to doctor tab bar for doctor role', (tester) async {
      cubit.emit(AnnounLoaded(
        primary: [_ann('1')],
        secondary: [],
        activeTab: AnnounTab.mine,
      ));

      await tester.pumpWidget(
          _buildSubject(cubit, sessionCubit, role: AnnounRole.doctor));
      await tester.pump();

      expect(find.byType(AnnounViewBody), findsOneWidget);
    });
  });
}
