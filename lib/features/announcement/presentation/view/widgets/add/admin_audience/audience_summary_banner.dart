import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';

class AudienceSummaryBanner extends StatelessWidget {
  final AdminUserType userType;
  final Set<String> selectedDepartments;
  final Set<String> selectedLevels;

  const AudienceSummaryBanner({
    super.key,
    required this.userType,
    required this.selectedDepartments,
    required this.selectedLevels,
  });

  bool get _hasFilters =>
      selectedDepartments.isNotEmpty || selectedLevels.isNotEmpty;

  String _summaryText(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_hasFilters) {
      return switch (userType) {
        AdminUserType.all => l10n.visibleToAll,
        AdminUserType.students => l10n.visibleToAllStudents,
        AdminUserType.doctors => l10n.visibleToAllDoctors,
        AdminUserType.ta => l10n.visibleToAllAssistants,
        AdminUserType.specificUsers => l10n.visibleToSelectedUsers,
      };
    }

    final parts = <String>[];
    if (selectedDepartments.isNotEmpty) {
      final names = selectedDepartments
          .map((d) => d.split(' ').take(2).join(' '))
          .join(', ');
      parts.add('$names ${l10n.deptSuffix}');
    }
    if (selectedLevels.isNotEmpty) {
      final names = selectedLevels
          .map((lvl) => '${l10n.level} ${lvl.replaceFirst('Level ', '')}')
          .join(' & ');
      parts.add(names);
    }

    return l10n.visibleToStudentsIn(parts.join(' — '));
  }

  @override
  Widget build(BuildContext context) {
    final isFiltered = _hasFilters;
    final color = isFiltered ? AppColors.info : AppColors.success;
    final bgColor = isFiltered ? AppColors.infoLight : AppColors.successLight;
    final textColor = isFiltered
        ? const Color(0xff1E40AF)
        : const Color(0xff065F46);
    final icon = isFiltered ? Icons.filter_alt_rounded : Icons.public_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadius.small,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(
              _summaryText(context),
              style: AppTextStyles.labelLarge.copyWith(
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
