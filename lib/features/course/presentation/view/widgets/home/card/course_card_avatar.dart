import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

class CourseCardAvatar extends StatelessWidget {
  final Course course;
  final double size;

  const CourseCardAvatar({
    super.key,
    required this.course,
    this.size = 54,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'course_hero_${course.id}',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: course.accentColor,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          course.initials,
          style: AppTextStyles.heading4.copyWith(
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
