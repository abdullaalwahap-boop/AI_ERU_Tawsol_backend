import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_required_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/dr_audience/dr_audience_course_content.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/dr_audience/dr_specific_students_content.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/dr_audience/dr_type_card.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';

class AddAnnounDrAudienceSelector extends StatelessWidget {
  final AddAnnounState state;
  final void Function(DrAudienceType) onTypeSelected;
  final void Function(String) onSelectCourse;
  final void Function(String) onToggleCourseFilter;
  final void Function(String) onSearchRecipients;
  final void Function(int) onToggleRecipient;

  const AddAnnounDrAudienceSelector({
    super.key,
    required this.state,
    required this.onTypeSelected,
    required this.onSelectCourse,
    required this.onToggleCourseFilter,
    required this.onSearchRecipients,
    required this.onToggleRecipient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppLocalizations.of(context).targetAudience,
          trailing: const AddAnnounRequiredBadge(),
        ),
        AppSpacing.h14,
        Row(
          children: DrAudienceType.values.map((type) {
            final isLast = type == DrAudienceType.values.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 12),
                child: DrTypeCard(
                  type: type,
                  isSelected: state.drAudienceType == type,
                  onTap: () => onTypeSelected(type),
                ),
              ),
            );
          }).toList(),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: state.drAudienceType == DrAudienceType.specificStudents
                ? DrSpecificStudentsContent(
                    state: state,
                    onToggleCourseFilter: onToggleCourseFilter,
                    onSearch: onSearchRecipients,
                    onToggle: onToggleRecipient,
                  )
                : DrAudienceCourseContent(
                    courses: state.courses,
                    selected: state.selectedOptions,
                    onSelect: onSelectCourse,
                  ),
          ),
        ),
      ],
    );
  }
}
