import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_option_chip.dart';

class AdminFilterGroup extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> options;
  final Set<String> selected;
  final void Function(String) onToggle;

  const AdminFilterGroup({
    super.key,
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
