import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/card/course_card_avatar.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/card/course_card_code_badge.dart';

class CourseCardHeader extends StatelessWidget {
  final Course course;

  const CourseCardHeader({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CourseCardAvatar(course: course),
        AppSpacing.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.h4,
              CourseCardCodeBadge(course: course),
              AppSpacing.h4,
              Text(
                course.doctorName,
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded,
            color: AppColors.textHint, size: 22),
      ],
    );
  }
}
