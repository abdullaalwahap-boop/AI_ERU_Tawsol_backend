import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum ProfileThemeOption {
  light('Light', Icons.light_mode_rounded),
  dark('Dark', Icons.dark_mode_rounded),
  system('System', Icons.brightness_auto_rounded);

  final String label;
  final IconData icon;
  const ProfileThemeOption(this.label, this.icon);
}

enum ProfileLangOption {
  english('English'),
  arabic('العربية');

  final String label;
  const ProfileLangOption(this.label);
}

class ProfilePickerSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final IconData Function(T) iconOf;
  final ValueChanged<T> onSelected;

  const ProfilePickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.iconOf,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.bottomSheet,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dividerLight,
              borderRadius: AppRadius.circular,
            ),
          ),
          AppSpacing.h16,
          Text(
            title,
            style: AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
          ),
          AppSpacing.h20,
          ...options.map((opt) {
            final isSelected = opt == selected;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppRadius.large,
                onTap: () => onSelected(opt),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.md,
                  ),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: AppRadius.large,
                        )
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        iconOf(opt),
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 22,
                      ),
                      AppSpacing.w16,
                      Expanded(
                        child: Text(
                          labelOf(opt),
                          style: AppTextStyles.titleSmall.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
