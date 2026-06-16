import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/courses_cubit/courses_cubit.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/course_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_app_wrapper.dart';

class _MockCourseRepo extends Mock implements CourseRepo {}

const _course = Course(
  id: 'CS101',
  name: 'Intro to CS',
  code: 'CS101',
  doctorName: 'Dr. Smith',
  description: 'Fundamentals',
  accentColor: Color(0xff3D6FFF),
  studentCount: 30,
  contentCount: 5,
);

Widget _buildSubject(
  CoursesCubit cubit, {
  CourseRole role = CourseRole.student,
}) =>
    testWrap(
      BlocProvider.value(
        value: cubit,
        child: CourseViewBody(role: role),
      ),
    );

void main() {
  late _MockCourseRepo repo;
  late CoursesCubit cubit;

  setUp(() {
    repo = _MockCourseRepo();
    cubit = CoursesCubit(repo);
  });

  tearDown(() => cubit.close());

  group('CourseViewBody', () {
    testWidgets('renders loading skeleton when state is CoursesLoading',
        (tester) async {
      cubit.emit(CoursesLoading());

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      // Skeleton uses staggered shimmer timers — verify no content then drain timers
      expect(find.byType(CourseViewBody), findsOneWidget);
      expect(find.text('Intro to CS'), findsNothing);

      // Drain pending shimmer animation timers to avoid !timersPending assertion
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('renders error message when state is CoursesError',
        (tester) async {
      cubit.emit(const CoursesError('Network error'));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('renders course cards when loaded', (tester) async {
      cubit.emit(const CoursesLoaded(courses: [_course]));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('Intro to CS'), findsOneWidget);
    });

    testWidgets('renders no course cards when loaded with empty list',
        (tester) async {
      cubit.emit(const CoursesLoaded(courses: []));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('Intro to CS'), findsNothing);
    });

    testWidgets('renders same skeleton for CoursesInitial', (tester) async {
      // CoursesInitial is the initial state before any load call
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('Intro to CS'), findsNothing);
    });
  });
}
