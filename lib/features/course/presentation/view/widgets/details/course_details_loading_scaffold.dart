import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/shared/white_back_button.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/states/courses_loading_skeleton.dart';

class CourseDetailsLoadingScaffold extends StatelessWidget {
  final Course course;

  const CourseDetailsLoadingScaffold({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: course.accentColor,
            expandedHeight: 180,
            pinned: true,
            leading: const WhiteBackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      course.accentColor.withValues(alpha: 0.85),
                      course.accentColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: CoursesLoadingSkeleton()),
        ],
      ),
    );
  }
}
