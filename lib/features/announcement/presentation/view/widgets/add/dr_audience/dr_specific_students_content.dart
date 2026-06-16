import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_recipient_search.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/dr_audience/dr_audience_course_chip.dart';

class DrSpecificStudentsContent extends StatelessWidget {
  final AddAnnounState state;
  final void Function(String) onToggleCourseFilter;
  final void Function(String) onSearch;
  final void Function(int) onToggle;

  const DrSpecificStudentsContent({
    super.key,
    required this.state,
    required this.onToggleCourseFilter,
    required this.onSearch,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.courses.length > 1) ...[
          Row(
            children: [
              Text(
                AppLocalizations.of(context).filterByCourse,
                style: AppTextStyles.labelMedium.copyWith(
                  color: context.colorTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.w6,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colorDivider,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppLocalizations.of(context).optional,
                  style: AppTextStyles.overline.copyWith(
                    color: context.colorTextHint,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h8,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.courses
                .map((c) => DrAudienceCourseChip(
                      course: c,
                      isSelected: state.selectedCourseId == c.id,
                      onTap: () => onToggleCourseFilter(c.id),
                    ))
                .toList(),
          ),
          AppSpacing.h16,
        ],
        AddAnnounRecipientSearch(
          recipients: state.recipients,
          isLoading: state.isLoadingRecipients,
          selectedIds: state.selectedRecipientIds,
          onSearch: onSearch,
          onToggle: onToggle,
        ),
      ],
    );
  }
}
