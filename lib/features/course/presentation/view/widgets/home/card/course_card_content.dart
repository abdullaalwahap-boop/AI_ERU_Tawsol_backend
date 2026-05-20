import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/card/course_card_header.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/card/course_card_info_row.dart';

class CourseCardContent extends StatelessWidget {
  final Course course;

  const CourseCardContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.xlarge,
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: course.accentColor.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseCardHeader(course: course),
            AppSpacing.h12,
            const Divider(color: AppColors.dividerLight, height: 1),
            AppSpacing.h10,
            CourseCardInfoRow(course: course),
          ],
        ),
      ),
    );
  }
}
