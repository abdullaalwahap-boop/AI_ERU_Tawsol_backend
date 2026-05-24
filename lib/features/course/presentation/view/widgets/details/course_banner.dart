import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_banner_background.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/shared/white_back_button.dart';

class CourseBanner extends StatelessWidget {
  final Course course;

  const CourseBanner({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: course.accentColor,
      leading: const WhiteBackButton(),
      flexibleSpace: FlexibleSpaceBar(
        background: CourseBannerBackground(course: course),
      ),
    );
  }
}
