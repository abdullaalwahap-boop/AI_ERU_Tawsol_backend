import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/states/feature_empty_state.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/card/course_card.dart';

class CoursesList extends StatelessWidget {
  final List<Course> courses;
  final CourseRole role;

  const CoursesList({super.key, required this.courses, required this.role});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const FeatureEmptyState(
        icon: Icons.school_outlined,
        title: 'No Courses Yet',
        description:
            'You have no courses assigned this semester.\nCheck back later for updates.',
        accentColor: AppColors.primary,
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 24),
      itemCount: courses.length,
      itemBuilder: (context, index) => CourseCard(
        course: courses[index],
        index: index,
        onTap: () => context.push(
          AppRouter.kCourseDetailsView,
          extra: CourseDetailsArgs(course: courses[index], role: role),
        ),
      ),
    );
  }
}
