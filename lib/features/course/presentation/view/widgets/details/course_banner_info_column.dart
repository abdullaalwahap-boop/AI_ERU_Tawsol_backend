import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

class CourseBannerInfoColumn extends StatelessWidget {
  final Course course;

  const CourseBannerInfoColumn({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.name,
          style: AppTextStyles.heading3.copyWith(
            color: Colors.white,
            letterSpacing: -0.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.h4,
        Text(
          course.code,
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.65),
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (course.description.isNotEmpty) ...[
          AppSpacing.h8,
          Text(
            course.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.55,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
