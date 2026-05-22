import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/card/course_info_chip.dart';

class CourseCardInfoRow extends StatelessWidget {
  final Course course;
  final CourseRole role;

  const CourseCardInfoRow({super.key, required this.course, required this.role});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (role != CourseRole.student) ...[
          CourseInfoChip(
            icon: Icons.people_rounded,
            label: '${course.studentCount} students',
            color: AppColors.primary,
          ),
          AppSpacing.w8,
        ],
        CourseInfoChip(
          icon: Icons.library_books_rounded,
          label: '${course.contentCount} items',
          color: course.accentColor,
        ),
      ],
    );
  }
}
