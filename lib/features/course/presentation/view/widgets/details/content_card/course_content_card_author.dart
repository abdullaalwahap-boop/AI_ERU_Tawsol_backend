import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/extensions/content_type_ui_ext.dart';

class CourseContentCardAuthor extends StatelessWidget {
  final CourseContent content;

  const CourseContentCardAuthor({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final typeColor = content.type.color;

    return Expanded(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.medium,
            ),
            alignment: Alignment.center,
            child: Text(
              content.authorInitials,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w800,
                color: typeColor,
              ),
            ),
          ),
          AppSpacing.w10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.authorName,
                  style: AppTextStyles.labelSmall.copyWith(color: typeColor),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 1),
                Text(
                  content.timeAgo,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
