import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_option_chip.dart';

class AdminLevelGroup extends StatelessWidget {
  final List<int> availableYears;
  final Set<String> selectedLevels;
  final void Function(String) onToggle;

  const AdminLevelGroup({
    super.key,
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
