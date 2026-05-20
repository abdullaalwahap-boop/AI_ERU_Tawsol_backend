import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

class CourseCardCodeBadge extends StatelessWidget {
  final Course course;
  const CourseCardCodeBadge({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: course.accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        course.code,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 11,
          color: course.accentColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
