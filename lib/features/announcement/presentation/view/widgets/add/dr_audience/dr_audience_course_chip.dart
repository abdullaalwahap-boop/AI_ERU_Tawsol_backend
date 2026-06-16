import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';

class DrAudienceCourseChip extends StatelessWidget {
  final CourseOption course;
  final bool isSelected;
  final VoidCallback onTap;

  const DrAudienceCourseChip({
    super.key,
    required this.course,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : context.colorInputBg,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.6)
                : context.colorDivider,
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              course.id,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                color:
                    isSelected ? AppColors.primary : context.colorTextSecondary,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              course.name,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? AppColors.primary : context.colorTextPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
