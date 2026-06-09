import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_option_chip.dart';
import 'package:flutter/material.dart';

/// Department + level filter shown only for Students target type.
/// Both departments and levels are multi-select.
class AddAnnounAdminFilterSection extends StatelessWidget {
  final List<String> departments;
  final Set<String> selectedDepartments;
  final void Function(String) onDeptToggle;

  final List<int> availableYears;    // computed from selectedDepartments
  final Set<String> selectedLevels;  // multi-select set of "Level X" strings
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
        _FilterGroup(
          label: AppLocalizations.of(context).department,
          icon: Icons.account_balance_rounded,
          options: departments,
          selected: selectedDepartments,
          onToggle: onDeptToggle,
        ),
        if (availableYears.isNotEmpty) ...[
          AppSpacing.h14,
          _LevelGroup(
            availableYears: availableYears,
            selectedLevels: selectedLevels,
            onToggle: onLevelToggle,
          ),
        ],
      ],
    );
  }
}

class _FilterGroup extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> options;
  final Set<String> selected;
  final void Function(String) onToggle;

  const _FilterGroup({
    required this.label,
    required this.icon,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: context.colorTextSecondary),
            AppSpacing.w4,
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorTextSecondary,
                letterSpacing: 0.4,
              ),
            ),
            if (selected.isNotEmpty) ...[
              AppSpacing.w6,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${selected.length}',
                  style: AppTextStyles.overline.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ],
        ),
        AppSpacing.h8,
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: options
              .map((opt) => AddAnnounOptionChip(
                    label: opt,
                    isSelected: selected.contains(opt),
                    onTap: () => onToggle(opt),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

/// Multi-select level chips.
class _LevelGroup extends StatelessWidget {
  final List<int> availableYears;
  final Set<String> selectedLevels;
  final void Function(String) onToggle;

  const _LevelGroup({
    required this.availableYears,
    required this.selectedLevels,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.layers_rounded, size: 13, color: context.colorTextSecondary),
            AppSpacing.w4,
            Text(
              AppLocalizations.of(context).level,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorTextSecondary,
                letterSpacing: 0.4,
              ),
            ),
            if (selectedLevels.isNotEmpty) ...[
              AppSpacing.w6,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${selectedLevels.length}',
                  style: AppTextStyles.overline.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ],
        ),
        AppSpacing.h8,
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: availableYears.map((y) {
            final key = 'Level $y';
            return AddAnnounOptionChip(
              label: '${AppLocalizations.of(context).level} $y',
              isSelected: selectedLevels.contains(key),
              onTap: () => onToggle(key),
            );
          }).toList(),
        ),
      ],
    );
  }
}
