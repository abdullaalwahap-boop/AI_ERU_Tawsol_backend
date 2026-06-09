import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/settings/cubit/settings_cubit.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_nav_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_toggle_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/settings/settings_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsSection extends StatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  State<ProfileSettingsSection> createState() => _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState extends State<ProfileSettingsSection> {
  bool _notifications = true;

  // ── Converters ─────────────────────────────────────────────────────────────

  static ProfileThemeOption _modeToOption(ThemeMode mode) => switch (mode) {
        ThemeMode.dark   => ProfileThemeOption.dark,
        ThemeMode.system => ProfileThemeOption.system,
        _                => ProfileThemeOption.light,
      };

  static ThemeMode _optionToMode(ProfileThemeOption option) => switch (option) {
        ProfileThemeOption.dark   => ThemeMode.dark,
        ProfileThemeOption.system => ThemeMode.system,
        _                         => ThemeMode.light,
      };

  static ProfileLangOption _localeToOption(Locale locale) =>
      locale.languageCode == 'ar'
          ? ProfileLangOption.arabic
          : ProfileLangOption.english;

  static Locale _optionToLocale(ProfileLangOption option) =>
      option == ProfileLangOption.arabic
          ? const Locale('ar')
          : const Locale('en');

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n   = AppLocalizations.of(context);
    final cubit  = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        final themeOption = _modeToOption(settings.themeMode);
        final langOption  = _localeToOption(settings.locale);

        return ProfileSectionCard(
          title: l10n.preferences,
          titleIcon: Icons.tune_rounded,
          children: [
            ProfileNavTile(
              icon: themeOption.icon,
              iconColor: AppColors.contentPurple,
              iconBg: AppColors.contentPurpleLight,
              title: l10n.appearance,
              subtitle: _themeLabel(l10n, themeOption),
              onTap: () => _showThemePicker(context, cubit, themeOption),
            ),
            ProfileToggleTile(
              icon: Icons.notifications_none_rounded,
              iconColor: AppColors.contentAmber,
              iconBg: AppColors.contentAmberLight,
              title: l10n.pushNotifications,
              subtitle: _notifications ? l10n.enabled : l10n.disabled,
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            ProfileNavTile(
              icon: Icons.language_rounded,
              iconColor: AppColors.contentCyan,
              iconBg: AppColors.contentCyanLight,
              title: l10n.language,
              subtitle: langOption.label,
              onTap: () => _showLanguagePicker(context, cubit, langOption),
            ),
          ],
        );
      },
    );
  }

  // ── Pickers ────────────────────────────────────────────────────────────────

  void _showThemePicker(
    BuildContext context,
    SettingsCubit cubit,
    ProfileThemeOption current,
  ) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfilePickerSheet<ProfileThemeOption>(
        title: l10n.appearance,
        options: ProfileThemeOption.values,
        selected: current,
        labelOf: (o) => _themeLabel(l10n, o),
        iconOf: (o) => o.icon,
        onSelected: (v) {
          cubit.setThemeMode(_optionToMode(v));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    SettingsCubit cubit,
    ProfileLangOption current,
  ) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfilePickerSheet<ProfileLangOption>(
        title: l10n.language,
        options: ProfileLangOption.values,
        selected: current,
        labelOf: (o) => o.label,
        iconOf: (_) => Icons.language_rounded,
        onSelected: (v) {
          cubit.setLocale(_optionToLocale(v));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _themeLabel(AppLocalizations l10n, ProfileThemeOption opt) =>
      switch (opt) {
        ProfileThemeOption.dark   => l10n.darkMode,
        ProfileThemeOption.system => l10n.systemDefault,
        _                         => l10n.lightMode,
      };
}
