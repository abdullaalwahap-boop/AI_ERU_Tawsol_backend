import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_nav_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_toggle_tile.dart';
import 'package:flutter/material.dart';

class ProfileSettingsSection extends StatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  State<ProfileSettingsSection> createState() => _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState extends State<ProfileSettingsSection> {
  bool _notifications = true;
  _ThemeOption _theme = _ThemeOption.light;
  _LangOption _lang = _LangOption.english;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'Preferences',
      titleIcon: Icons.tune_rounded,
      children: [
        ProfileNavTile(
          icon: _theme.icon,
          iconColor: AppColors.contentPurple,
          iconBg: AppColors.contentPurpleLight,
          title: 'Appearance',
          subtitle: _theme.label,
          onTap: () => _showThemePicker(context),
        ),
        ProfileToggleTile(
          icon: Icons.notifications_none_rounded,
          iconColor: AppColors.contentAmber,
          iconBg: AppColors.contentAmberLight,
          title: 'Push Notifications',
          subtitle: _notifications ? 'Enabled' : 'Disabled',
          value: _notifications,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        ProfileNavTile(
          icon: Icons.language_rounded,
          iconColor: AppColors.contentCyan,
          iconBg: AppColors.contentCyanLight,
          title: 'Language',
          subtitle: _lang.label,
          onTap: () => _showLanguagePicker(context),
        ),
      ],
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet<_ThemeOption>(
        title: 'Appearance',
        options: _ThemeOption.values,
        selected: _theme,
        labelOf: (o) => o.label,
        iconOf: (o) => o.icon,
        onSelected: (v) {
          setState(() => _theme = v);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet<_LangOption>(
        title: 'Language',
        options: _LangOption.values,
        selected: _lang,
        labelOf: (o) => o.label,
        iconOf: (o) => Icons.language_rounded,
        onSelected: (v) {
          setState(() => _lang = v);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

// ─── Enums ────────────────────────────────────────────────────────────────────

enum _ThemeOption {
  light('Light', Icons.light_mode_rounded),
  dark('Dark', Icons.dark_mode_rounded),
  system('System', Icons.brightness_auto_rounded);

  final String label;
  final IconData icon;
  const _ThemeOption(this.label, this.icon);
}

enum _LangOption {
  english('English'),
  arabic('العربية');

  final String label;
  const _LangOption(this.label);
}

// ─── Generic Picker Sheet ─────────────────────────────────────────────────────

class _PickerSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final IconData Function(T) iconOf;
  final ValueChanged<T> onSelected;

  const _PickerSheet({
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
        AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxxl,
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
            style:
                AppTextStyles.heading4.copyWith(color: AppColors.textPrimary),
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
