import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
import 'package:flutter/material.dart';

class AddAnnounAdminAudienceSummary extends StatelessWidget {
  final AdminUserType? userType;
  final Set<String> selectedDepartments;
  final Set<String> selectedLevels;

  const AddAnnounAdminAudienceSummary({
    super.key,
    required this.userType,
    required this.selectedDepartments,
    required this.selectedLevels,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: child,
        ),
      ),
      child: userType == null
          ? const SizedBox.shrink()
          : _SummaryBanner(
              key: ValueKey(
                '${userType!.name}'
                '-${selectedDepartments.join()}'
                '-${selectedLevels.join()}',
              ),
              userType: userType!,
              selectedDepartments: selectedDepartments,
              selectedLevels: selectedLevels,
            ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final AdminUserType userType;
  final Set<String> selectedDepartments;
  final Set<String> selectedLevels;

  const _SummaryBanner({
    super.key,
    required this.userType,
    required this.selectedDepartments,
    required this.selectedLevels,
  });

  bool get _hasFilters =>
      selectedDepartments.isNotEmpty || selectedLevels.isNotEmpty;

  String get _summaryText {
    if (!_hasFilters) {
      return switch (userType) {
        AdminUserType.all => 'Visible to all students and doctors',
        AdminUserType.students => 'Visible to all students',
        AdminUserType.doctors => 'Visible to all doctors',
      };
    }

    final who = switch (userType) {
      AdminUserType.all => 'all users',
      AdminUserType.students => 'students',
      AdminUserType.doctors => 'doctors',
    };

    final parts = <String>[];
    if (selectedDepartments.isNotEmpty) {
      final names =
          selectedDepartments.map((d) => d.split(' ').take(2).join(' ')).join(', ');
      parts.add('$names dept.');
    }
    if (selectedLevels.isNotEmpty) {
      final names =
          selectedLevels.map((l) => l.replaceFirst('Level ', 'L')).join(' & ');
      parts.add(names);
    }

    return 'Visible to $who in ${parts.join(' — ')}';
  }

  @override
  Widget build(BuildContext context) {
    final isFiltered = _hasFilters;
    final color = isFiltered ? AppColors.info : AppColors.success;
    final bgColor = isFiltered ? AppColors.infoLight : AppColors.successLight;
    final textColor = isFiltered
        ? const Color(0xff1E40AF)
        : const Color(0xff065F46);
    final icon = isFiltered
        ? Icons.filter_alt_rounded
        : Icons.public_rounded;

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
              _summaryText,
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
