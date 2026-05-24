import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
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
                  _CourseAvatar(course: course),
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

class _CourseAvatar extends StatelessWidget {
  final Course course;

  const _CourseAvatar({required this.course});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'course_hero_${course.id}',
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          course.initials,
          style: AppTextStyles.heading3.copyWith(
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
