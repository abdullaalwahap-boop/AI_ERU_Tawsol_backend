import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_admin_audience_summary.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_admin_filter_section.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_user_type_selector.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_required_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';
import 'package:flutter/material.dart';

class AddAnnounAdminAudienceSelector extends StatelessWidget {
  final AddAnnounState state;
  final void Function(AdminUserType) onUserTypeSelected;
  final void Function(String) onDeptToggle;
  final void Function(String) onLevelToggle;
  final List<String> departments;
  final List<String> levels;

  const AddAnnounAdminAudienceSelector({
    super.key,
    required this.state,
    required this.onUserTypeSelected,
    required this.onDeptToggle,
    required this.onLevelToggle,
    required this.departments,
    required this.levels,
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
                      if (state.adminUserType != AdminUserType.all) ...[
                        AddAnnounAdminFilterSection(
                          departments: departments,
                          selectedDepartments: state.selectedDepartments,
                          onDeptToggle: onDeptToggle,
                          levels: levels,
                          selectedLevels: state.selectedLevels,
                          onLevelToggle: onLevelToggle,
                        ),
                        AppSpacing.h14,
                      ],
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
