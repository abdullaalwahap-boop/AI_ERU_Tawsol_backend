import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_admin_audience_summary.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_admin_filter_section.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_user_type_selector.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_recipient_search.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_required_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';
import 'package:flutter/material.dart';

class AddAnnounAdminAudienceSelector extends StatelessWidget {
  final AddAnnounState state;
  final void Function(AdminUserType) onUserTypeSelected;
  final void Function(String) onDeptToggle;
  final void Function(String) onLevelToggle;
  final List<String> departments;
  final List<int> availableYears;
  final void Function(String) onSearchRecipients;
  final void Function(int) onToggleRecipient;

  const AddAnnounAdminAudienceSelector({
    super.key,
    required this.state,
    required this.onUserTypeSelected,
    required this.onDeptToggle,
    required this.onLevelToggle,
    required this.departments,
    required this.availableYears,
    required this.onSearchRecipients,
    required this.onToggleRecipient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Target Audience',
          trailing: const AddAnnounRequiredBadge(),
        ),
        AppSpacing.h14,
        AddAnnounUserTypeSelector(
          selected: state.adminUserType,
          onSelected: onUserTypeSelected,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: state.adminUserType == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Students: optional department + level filter
                      if (state.adminUserType!.hasStudentFilter) ...[
                        AddAnnounAdminFilterSection(
                          departments: departments,
                          selectedDepartments: state.selectedDepartments,
                          onDeptToggle: onDeptToggle,
                          availableYears: availableYears,
                          selectedLevels: state.selectedLevels,
                          onLevelToggle: onLevelToggle,
                        ),
                        AppSpacing.h14,
                      ],
                      // Specific users: search bar + selected chips
                      if (state.adminUserType!.needsRecipientSearch) ...[
                        AddAnnounRecipientSearch(
                          recipients: state.recipients,
                          isLoading: state.isLoadingRecipients,
                          selectedIds: state.selectedRecipientIds,
                          onSearch: onSearchRecipients,
                          onToggle: onToggleRecipient,
                        ),
                        AppSpacing.h14,
                      ],
                      // Summary banner (shown for all types except specificUsers)
                      if (!state.adminUserType!.needsRecipientSearch)
                        AddAnnounAdminAudienceSummary(
                          userType: state.adminUserType,
                          selectedDepartments: state.selectedDepartments,
                          selectedLevels: state.selectedLevels,
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
