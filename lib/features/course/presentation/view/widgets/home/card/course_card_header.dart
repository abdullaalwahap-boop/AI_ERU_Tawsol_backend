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
                style: AppTextStyles.titleMedium.copyWith(color: context.colorTextPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.h4,
              CourseCardCodeBadge(course: course),
              if (course.doctorName.isNotEmpty) ...[
                AppSpacing.h5,
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 12,
                      color: context.colorTextHint,
                    ),
                    AppSpacing.w4,
                    Expanded(
                      child: Text(
                        course.doctorName,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: context.colorTextHint),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded,
            color: context.colorTextHint, size: 22),
      ],
    );
  }
}
