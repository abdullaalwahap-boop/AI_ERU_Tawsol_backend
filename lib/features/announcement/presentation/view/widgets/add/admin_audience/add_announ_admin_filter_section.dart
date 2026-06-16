import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/admin_filter_group.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/admin_level_group.dart';

class AddAnnounAdminFilterSection extends StatelessWidget {
  final List<String> departments;
  final Set<String> selectedDepartments;
  final void Function(String) onDeptToggle;

  final List<int> availableYears;
  final Set<String> selectedLevels;
  final void Function(String) onLevelToggle;

  const AddAnnounAdminFilterSection({
    super.key,
    required this.departments,
    required this.selectedDepartments,
    required this.onDeptToggle,
    required this.availableYears,
    required this.selectedLevels,
    required this.onLevelToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminFilterGroup(
          label: AppLocalizations.of(context).department,
          icon: Icons.account_balance_rounded,
          options: departments,
          selected: selectedDepartments,
          onToggle: onDeptToggle,
        ),
        if (availableYears.isNotEmpty) ...[
          AppSpacing.h14,
          AdminLevelGroup(
            availableYears: availableYears,
            selectedLevels: selectedLevels,
            onToggle: onLevelToggle,
          ),
        ],
      ],
    );
  }
}
