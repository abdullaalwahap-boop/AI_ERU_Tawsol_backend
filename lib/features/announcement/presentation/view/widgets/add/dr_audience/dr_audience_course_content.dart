import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/dr_audience/dr_audience_course_chip.dart';

class DrAudienceCourseContent extends StatelessWidget {
  final List<CourseOption> courses;
  final Set<String> selected;
  final void Function(String) onSelect;

  const DrAudienceCourseContent({
    super.key,
    required this.courses,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: context.colorInputBg,
          borderRadius: AppRadius.medium,
          border: Border.all(color: context.colorDivider),
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
              AppLocalizations.of(context).loadingCourses,
              style: AppTextStyles.labelMedium
                  .copyWith(color: context.colorTextHint),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).selectSubject,
          style: AppTextStyles.labelMedium.copyWith(
            color: context.colorTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.h10,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: courses
              .map((c) => DrAudienceCourseChip(
                    course: c,
                    isSelected: selected.contains(c.id),
                    onTap: () => onSelect(c.id),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
