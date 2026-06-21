import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnnounRepo extends Mock implements AnnounRepo {}

Announcement _ann(
  String id, {
  AnnouncementType type = AnnouncementType.normal,
  AnnouncementPriority priority = AnnouncementPriority.normal,
  bool isRead = false,
  int authorId = 1,
}) =>
    Announcement(
      id: id,
      title: 'Title $id',
      body: 'Body $id',
      doctorName: 'Dr. Test',
      subjectName: 'Subject',
      subjectCode: 'CS101',
      type: type,
      target: AnnouncementTarget.all,
      priority: priority,
      createdAt: DateTime(2024, 1, int.parse(id)),
      isRead: isRead,
      authorId: authorId,
    );

void main() {
  late _MockAnnounRepo repo;

  setUp(() => repo = _MockAnnounRepo());

  group('AnnounCubit', () {
    test('initial state is AnnounInitial', () {
      expect(AnnounCubit(repo).state, isA<AnnounInitial>());
    });

    // ── loadForStudent ────────────────────────────────────────────────────────

    group('loadForStudent', () {
      final items = [_ann('1'), _ann('2'), _ann('3')];

      blocTest<AnnounCubit, AnnounState>(
        'emits [AnnounLoading, AnnounLoaded] with primary list',
        build: () {
          when(() => repo.getAllAnnouncements()).thenAnswer((_) async => items);
          return AnnounCubit(repo);
        },
        act: (c) => c.loadForStudent(),
        expect: () => [
          isA<AnnounLoading>(),
          isA<AnnounLoaded>()
              .having((s) => s.primary.length, 'primary.length', 3)
              .having((s) => s.secondary, 'secondary', isEmpty),
        ],
      );

      blocTest<AnnounCubit, AnnounState>(
        'emits AnnounError on failure',
        build: () {
          when(() => repo.getAllAnnouncements())
              .thenThrow(Exception('Network error'));
          return AnnounCubit(repo);
        },
        act: (c) => c.loadForStudent(),
        expect: () => [
          isA<AnnounLoading>(),
          isA<AnnounError>(),
        ],
      );
    });

    // ── loadForDoctor ─────────────────────────────────────────────────────────

    group('loadForDoctor', () {
      final mine = [_ann('1', authorId: 10), _ann('2', authorId: 10)];
      final all = [
        _ann('1', authorId: 10),
        _ann('3', authorId: 99), // admin announcement
      ];

      blocTest<AnnounCubit, AnnounState>(
        'loads primary=mine and secondary=others (filtered by doctorUserId)',
        build: () {
          when(() => repo.getMyAnnouncements()).thenAnswer((_) async => mine);
          when(() => repo.getAllAnnouncements()).thenAnswer((_) async => all);
          return AnnounCubit(repo);
        },
        act: (c) => c.loadForRole(AnnounRole.doctor, userId: 10),
        expect: () => [
          isA<AnnounLoading>(),
          isA<AnnounLoaded>()
              .having((s) => s.primary.length, 'primary (mine)', 2)
              // secondary excludes doctor's own announcements
              .having((s) => s.secondary.length, 'secondary (others)', 1)
              .having((s) => s.activeTab, 'activeTab', AnnounTab.mine),
        ],
      );
    });

    // ── loadForAdmin ──────────────────────────────────────────────────────────

    group('loadForAdmin', () {
      final sent = [_ann('1'), _ann('2')];

      blocTest<AnnounCubit, AnnounState>(
        'emits AnnounLoaded with admin sent list',
        build: () {
          when(() => repo.getAdminAnnouncements())
              .thenAnswer((_) async => sent);
          return AnnounCubit(repo);
        },
        act: (c) => c.loadForAdmin(),
        expect: () => [
          isA<AnnounLoading>(),
          isA<AnnounLoaded>().having((s) => s.primary.length, 'primary', 2),
        ],
      );
    });

    // ── Tab switching ─────────────────────────────────────────────────────────

    group('switchTab', () {
      blocTest<AnnounCubit, AnnounState>(
        'switches to admin tab and AnnounLoaded.current returns secondary',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [_ann('1'), _ann('2')],
          secondary: [_ann('3')],
          activeTab: AnnounTab.mine,
        ),
        act: (c) => c.switchTab(AnnounTab.admin),
        expect: () => [
          isA<AnnounLoaded>()
              .having((s) => s.activeTab, 'activeTab', AnnounTab.admin)
              .having((s) => s.current.length, 'current (secondary)', 1),
        ],
      );

      blocTest<AnnounCubit, AnnounState>(
        'switching tab clears active type filter',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [_ann('1')],
          activeFilter: AnnouncementType.assignment,
        ),
        act: (c) => c.switchTab(AnnounTab.admin),
        expect: () => [
          isA<AnnounLoaded>().having(
            (s) => s.activeFilter,
            'filter cleared',
            null,
          ),
        ],
      );
    });

    // ── filterByType ──────────────────────────────────────────────────────────

    group('filterByType', () {
      blocTest<AnnounCubit, AnnounState>(
        'filters current list by announcement type',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [
            _ann('1', type: AnnouncementType.normal),
            _ann('2', type: AnnouncementType.assignment),
            _ann('3', type: AnnouncementType.normal),
          ],
        ),
        act: (c) => c.filterByType(AnnouncementType.assignment),
        expect: () => [
          isA<AnnounLoaded>().having(
            (s) => s.current.length,
            'filtered count',
            1,
          ),
        ],
      );

      blocTest<AnnounCubit, AnnounState>(
        'filterByType(null) clears filter',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [_ann('1'), _ann('2')],
          activeFilter: AnnouncementType.assignment,
        ),
        act: (c) => c.filterByType(null),
        expect: () => [
          isA<AnnounLoaded>()
              .having((s) => s.activeFilter, 'filter', null)
              .having((s) => s.current.length, 'all shown', 2),
        ],
      );
    });

    // ── filterByPriority ──────────────────────────────────────────────────────

    group('filterByPriority', () {
      blocTest<AnnounCubit, AnnounState>(
        'filters by priority and filterByPriority(null) clears it',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [
            _ann('1', priority: AnnouncementPriority.urgent),
            _ann('2', priority: AnnouncementPriority.normal),
          ],
        ),
        act: (c) async {
          c.filterByPriority(AnnouncementPriority.urgent);
          c.filterByPriority(null);
        },
        expect: () => [
          isA<AnnounLoaded>().having((s) => s.current.length, 'urgent only', 1),
          isA<AnnounLoaded>().having((s) => s.current.length, 'all', 2),
        ],
      );
    });

    // ── local actions ─────────────────────────────────────────────────────────

    group('localDelete', () {
      blocTest<AnnounCubit, AnnounState>(
        'removes announcement from both primary and secondary',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [_ann('1'), _ann('2')],
          secondary: [_ann('2'), _ann('3')],
        ),
        act: (c) => c.localDelete('2'),
        expect: () => [
          isA<AnnounLoaded>()
              .having((s) => s.primary.length, 'primary', 1)
              .having((s) => s.secondary.length, 'secondary', 1),
        ],
      );
    });

    group('localMarkRead', () {
      blocTest<AnnounCubit, AnnounState>(
        'marks announcement as read in both lists',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [_ann('1', isRead: false), _ann('2')],
          secondary: [_ann('1', isRead: false)],
        ),
        act: (c) => c.localMarkRead('1'),
        expect: () => [
          isA<AnnounLoaded>().having(
            (s) => s.primary.first.isRead,
            'primary[0].isRead',
            true,
          ),
        ],
      );
    });

    group('prependAnnouncement', () {
      blocTest<AnnounCubit, AnnounState>(
        'inserts new announcement at start of primary',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [_ann('1'), _ann('2')],
        ),
        act: (c) => c.prependAnnouncement(_ann('99')),
        expect: () => [
          isA<AnnounLoaded>()
              .having((s) => s.primary.first.id, 'first id', '99')
              .having((s) => s.primary.length, 'length', 3),
        ],
      );
    });

    group('replaceAnnouncement', () {
      blocTest<AnnounCubit, AnnounState>(
        'replaces announcement with same id in primary',
        build: () => AnnounCubit(repo),
        seed: () => AnnounLoaded(
          primary: [_ann('1'), _ann('2')],
        ),
        act: (c) => c.replaceAnnouncement(_ann('1').copyWith(title: 'Updated')),
        expect: () => [
          isA<AnnounLoaded>().having(
            (s) => s.primary.first.title,
            'updated title',
            'Updated',
          ),
        ],
      );
    });

    group('deleteAnnouncement', () {
      blocTest<AnnounCubit, AnnounState>(
        'removes from both lists and returns true on success',
        build: () {
          when(() => repo.deleteAnnouncement(any())).thenAnswer((_) async {});
          return AnnounCubit(repo);
        },
        seed: () => AnnounLoaded(
          primary: [_ann('1'), _ann('2')],
          secondary: [_ann('1')],
        ),
        act: (c) async {
          final result = await c.deleteAnnouncement(1);
          expect(result, true);
        },
        expect: () => [
          isA<AnnounLoaded>()
              .having((s) => s.primary.length, 'primary', 1)
              .having((s) => s.secondary.length, 'secondary', 0),
        ],
      );

      blocTest<AnnounCubit, AnnounState>(
        'emits AnnounError and returns false on failure',
        build: () {
          when(() => repo.deleteAnnouncement(any()))
              .thenThrow(Exception('Delete failed'));
          return AnnounCubit(repo);
        },
        seed: () => AnnounLoaded(primary: [_ann('1')]),
        act: (c) async {
          final result = await c.deleteAnnouncement(1);
          expect(result, false);
        },
        expect: () => [isA<AnnounError>()],
      );
    });

    // ── silentRefresh ─────────────────────────────────────────────────────────

    group('silentRefresh', () {
      blocTest<AnnounCubit, AnnounState>(
        'updates primary without emitting AnnounLoading',
        build: () {
          when(() => repo.getAllAnnouncements())
              .thenAnswer((_) async => [_ann('5'), _ann('6')]);
          return AnnounCubit(repo);
        },
        seed: () => AnnounLoaded(primary: [_ann('1')]),
        act: (c) => c.silentRefresh(AnnounRole.student),
        expect: () => [
          isA<AnnounLoaded>()
              .having((s) => s.primary.length, 'updated count', 2),
        ],
      );

      blocTest<AnnounCubit, AnnounState>(
        'does nothing when state is not AnnounLoaded',
        build: () {
          when(() => repo.getAllAnnouncements())
              .thenAnswer((_) async => [_ann('1')]);
          return AnnounCubit(repo);
        },
        seed: () => AnnounLoading(),
        act: (c) => c.silentRefresh(AnnounRole.student),
        expect: () => [],
      );
    });
  });
}
