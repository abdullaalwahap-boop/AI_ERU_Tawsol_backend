import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/course_details_cubit/course_details_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCourseRepo extends Mock implements CourseRepo {}

const _fakeCourse = Course(
  id: 'CS101',
  name: 'Intro to CS',
  code: 'CS101',
  doctorName: 'Dr. Smith',
  description: '',
  accentColor: Color(0xff3D6FFF),
  studentCount: 30,
  contentCount: 5,
);

CourseContent _content(String id, ContentType type) => CourseContent(
      id: id,
      title: 'Content $id',
      body: 'Body $id',
      type: type,
      createdAt: DateTime(2024, 1, 1),
      authorName: 'Dr. Smith',
    );

Announcement _ann(String id) => Announcement(
      id: id,
      title: 'Announcement $id',
      body: 'Body',
      doctorName: 'Dr. Smith',
      subjectName: 'CS',
      subjectCode: 'CS101',
      type: AnnouncementType.normal,
      target: AnnouncementTarget.all,
      priority: AnnouncementPriority.normal,
      createdAt: DateTime(2024, 1, 1),
    );

void main() {
  late _MockCourseRepo repo;

  setUp(() => repo = _MockCourseRepo());

  group('CourseDetailsCubit', () {
    test('initial state is CourseDetailsInitial', () {
      expect(CourseDetailsCubit(repo).state, isA<CourseDetailsInitial>());
    });

    // ── loadForStudent ────────────────────────────────────────────────────────

    group('loadForStudent', () {
      final content = [
        _content('1', ContentType.material),
        _content('2', ContentType.announcement),
      ];

      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'emits [Loading, Loaded] on success',
        build: () {
          when(() => repo.getAllCourseContent(_fakeCourse.id))
              .thenAnswer((_) async => content);
          return CourseDetailsCubit(repo);
        },
        act: (c) => c.loadForStudent(_fakeCourse),
        expect: () => [
          isA<CourseDetailsLoading>(),
          isA<CourseDetailsLoaded>()
              .having((s) => s.content.length, 'content count', 2)
              .having((s) => s.course.id, 'course id', 'CS101'),
        ],
      );

      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'emits CourseDetailsError on failure',
        build: () {
          when(() => repo.getAllCourseContent(any()))
              .thenThrow(Exception('Network error'));
          return CourseDetailsCubit(repo);
        },
        act: (c) => c.loadForStudent(_fakeCourse),
        expect: () => [
          isA<CourseDetailsLoading>(),
          isA<CourseDetailsError>(),
        ],
      );
    });

    // ── loadForDoctor ─────────────────────────────────────────────────────────

    group('loadForDoctor', () {
      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'calls getDoctorCourseContent and emits Loaded',
        build: () {
          when(() => repo.getDoctorCourseContent(_fakeCourse.id))
              .thenAnswer((_) async => [_content('1', ContentType.material)]);
          return CourseDetailsCubit(repo);
        },
        act: (c) => c.loadForDoctor(_fakeCourse),
        expect: () => [
          isA<CourseDetailsLoading>(),
          isA<CourseDetailsLoaded>(),
        ],
        verify: (_) =>
            verify(() => repo.getDoctorCourseContent(_fakeCourse.id)).called(1),
      );
    });

    // ── filterContent ─────────────────────────────────────────────────────────

    group('filterContent', () {
      final mixedContent = [
        _content('1', ContentType.material),
        _content('2', ContentType.announcement),
        _content('3', ContentType.material),
        _content('4', ContentType.assignment),
      ];

      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'filteredContent returns only matching type when filter is set',
        build: () => CourseDetailsCubit(repo),
        seed: () =>
            CourseDetailsLoaded(course: _fakeCourse, content: mixedContent),
        act: (c) => c.filterContent(ContentType.material),
        expect: () => [
          isA<CourseDetailsLoaded>().having(
            (s) => s.filteredContent.length,
            'filtered material count',
            2,
          ),
        ],
      );

      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'filterContent(null) shows all content',
        build: () => CourseDetailsCubit(repo),
        seed: () => CourseDetailsLoaded(
          course: _fakeCourse,
          content: mixedContent,
          activeFilter: ContentType.material,
        ),
        act: (c) => c.filterContent(null),
        expect: () => [
          isA<CourseDetailsLoaded>()
              .having((s) => s.activeFilter, 'filter cleared', null)
              .having((s) => s.filteredContent.length, 'all shown', 4),
        ],
      );

      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'does nothing when state is not CourseDetailsLoaded',
        build: () => CourseDetailsCubit(repo),
        seed: () => CourseDetailsInitial(),
        act: (c) => c.filterContent(ContentType.material),
        expect: () => [],
      );
    });

    // ── removeContent ─────────────────────────────────────────────────────────

    group('removeContent', () {
      final items = [
        _content('1', ContentType.material),
        _content('2', ContentType.announcement),
        _content('3', ContentType.assignment),
      ];

      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'removes content with matching id',
        build: () => CourseDetailsCubit(repo),
        seed: () =>
            CourseDetailsLoaded(course: _fakeCourse, content: items),
        act: (c) => c.removeContent('2'),
        expect: () => [
          isA<CourseDetailsLoaded>()
              .having((s) => s.content.length, 'length after remove', 2)
              .having(
                (s) => s.content.any((c) => c.id == '2'),
                'id 2 gone',
                false,
              ),
        ],
      );
    });

    // ── localMarkAnnouncementRead ─────────────────────────────────────────────

    group('localMarkAnnouncementRead', () {
      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'marks announcement as read without API call',
        build: () => CourseDetailsCubit(repo),
        seed: () {
          final contentWithAnn = CourseContent(
            id: 'ann-1',
            title: 'Ann',
            body: 'Body',
            type: ContentType.announcement,
            createdAt: DateTime(2024, 1, 1),
            authorName: 'Dr.',
            announcement: _ann('ann-1').copyWith(isRead: false),
          );
          return CourseDetailsLoaded(
            course: _fakeCourse,
            content: [contentWithAnn],
          );
        },
        act: (c) => c.localMarkAnnouncementRead('ann-1'),
        expect: () => [
          isA<CourseDetailsLoaded>().having(
            (s) => s.content.first.announcement?.isRead,
            'announcement.isRead',
            true,
          ),
        ],
      );
    });

    // ── updateAnnouncementContent ─────────────────────────────────────────────

    group('updateAnnouncementContent', () {
      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'replaces the announcement in the matching content item',
        build: () => CourseDetailsCubit(repo),
        seed: () {
          final contentWithAnn = CourseContent(
            id: 'ann-5',
            title: 'Old title',
            body: 'Old body',
            type: ContentType.announcement,
            createdAt: DateTime(2024, 1, 1),
            authorName: 'Dr.',
            announcement: _ann('ann-5'),
          );
          return CourseDetailsLoaded(
            course: _fakeCourse,
            content: [contentWithAnn],
          );
        },
        act: (c) => c.updateAnnouncementContent(
          _ann('ann-5').copyWith(title: 'New title'),
        ),
        expect: () => [
          isA<CourseDetailsLoaded>().having(
            (s) => s.content.first.title,
            'updated title',
            'New title',
          ),
        ],
      );
    });

    // ── silentRefresh ─────────────────────────────────────────────────────────

    group('silentRefresh', () {
      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'updates content without emitting CourseDetailsLoading',
        build: () {
          when(() => repo.getAllCourseContent(_fakeCourse.id))
              .thenAnswer((_) async => [
                    _content('10', ContentType.material),
                    _content('11', ContentType.announcement),
                    _content('12', ContentType.assignment),
                  ]);
          return CourseDetailsCubit(repo);
        },
        seed: () =>
            CourseDetailsLoaded(course: _fakeCourse, content: []),
        act: (c) => c.silentRefresh(CourseRole.student, _fakeCourse),
        expect: () => [
          isA<CourseDetailsLoaded>().having(
            (s) => s.content.length,
            'refreshed count',
            3,
          ),
        ],
      );

      blocTest<CourseDetailsCubit, CourseDetailsState>(
        'does nothing when state is not CourseDetailsLoaded',
        build: () => CourseDetailsCubit(repo),
        seed: () => CourseDetailsInitial(),
        act: (c) => c.silentRefresh(CourseRole.student, _fakeCourse),
        expect: () => [],
      );
    });
  });
}
