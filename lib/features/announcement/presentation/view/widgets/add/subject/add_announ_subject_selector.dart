import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_required_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';

/// Doctor-only subject selector — shows each course as a rich chip with both
/// the course code and name. Single-select; selection stored by course ID.
class AddAnnounSubjectSelector extends StatelessWidget {
  final List<CourseOption> courses;
  final Set<String> selected;
  final void Function(String courseId) onSelect;

  const AddAnnounSubjectSelector({
    super.key,
    required this.courses,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Subject',
            trailing: const AddAnnounRequiredBadge(),
          ),
          AppSpacing.h14,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.inputBgLight,
              borderRadius: AppRadius.medium,
              border: Border.all(color: AppColors.dividerLight),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                AppSpacing.w10,
                Text(
                  'Loading your courses…',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Subject',
          trailing: const AddAnnounRequiredBadge(),
        ),
        AppSpacing.h14,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: courses
              .map((course) => _CoursechIp(
                    course: course,
                    isSelected: selected.contains(course.id),
                    onTap: () => onSelect(course.id),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _CoursechIp extends StatelessWidget {
  final CourseOption course;
  final bool isSelected;
  final VoidCallback onTap;

  const _CoursechIp({
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
              : AppColors.inputBgLight,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.6)
                : AppColors.dividerLight,
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
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
                    isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
