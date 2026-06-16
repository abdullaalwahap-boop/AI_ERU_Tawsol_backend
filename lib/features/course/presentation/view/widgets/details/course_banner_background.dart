import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_avatar.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_banner_info_column.dart';

class CourseBannerBackground extends StatelessWidget {
  final Course course;

  const CourseBannerBackground({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          const Positioned(
            right: -4,
            top: 10,
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.school_rounded, size: 160, color: Colors.white),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CourseAvatar(course: course),
                  AppSpacing.w14,
                  Expanded(
                    child: CourseBannerInfoColumn(course: course),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
