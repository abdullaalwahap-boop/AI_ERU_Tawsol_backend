import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_option_chip.dart';
import 'package:flutter/material.dart';

class AddAnnounAdminFilterSection extends StatelessWidget {
  final List<String> departments;
  final Set<String> selectedDepartments;
  final void Function(String) onDeptToggle;

  final List<String> levels;
  final Set<String> selectedLevels;
  final void Function(String) onLevelToggle;

  const AddAnnounAdminFilterSection({
    super.key,
    required this.departments,
    required this.selectedDepartments,
    required this.onDeptToggle,
    required this.levels,
    required this.selectedLevels,
    required this.onLevelToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterGroup(
          label: 'Department',
          icon: Icons.account_balance_rounded,
          options: departments,
          selected: selectedDepartments,
          onToggle: onDeptToggle,
        ),
        AppSpacing.h14,
        _FilterGroup(
          label: 'Level',
          icon: Icons.layers_rounded,
          options: levels,
          selected: selectedLevels,
          onToggle: onLevelToggle,
        ),
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
            Icon(icon, size: 13, color: AppColors.textSecondary),
            AppSpacing.w4,
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
            if (selected.isNotEmpty) ...[
              AppSpacing.w6,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
