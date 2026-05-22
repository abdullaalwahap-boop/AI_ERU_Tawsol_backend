import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
import 'package:flutter/material.dart';

class AddAnnounUserTypeSelector extends StatelessWidget {
  final AdminUserType? selected;
  final void Function(AdminUserType) onSelected;

  const AddAnnounUserTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final types = AdminUserType.values;
    return Row(
      children: types.map((type) {
        final isLast = type == types.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 10),
            child: _UserTypePill(
              type: type,
              isSelected: selected == type,
              onTap: () => onSelected(type),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _UserTypePill extends StatelessWidget {
  final AdminUserType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserTypePill({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.inputBgLight,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.dividerLight,
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.dividerLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                type.icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textHint,
              ),
            ),
            AppSpacing.h4,
            Text(
              type.label,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
