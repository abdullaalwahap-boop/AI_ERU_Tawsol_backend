import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_nav_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_toggle_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/settings/settings_picker_sheet.dart';
import 'package:flutter/material.dart';

class ProfileSettingsSection extends StatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  State<ProfileSettingsSection> createState() => _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState extends State<ProfileSettingsSection> {
  bool _notifications = true;
  ProfileThemeOption _theme = ProfileThemeOption.light;
  ProfileLangOption _lang = ProfileLangOption.english;

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
      builder: (_) => ProfilePickerSheet<ProfileThemeOption>(
        title: 'Appearance',
        options: ProfileThemeOption.values,
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
      builder: (_) => ProfilePickerSheet<ProfileLangOption>(
        title: 'Language',
        options: ProfileLangOption.values,
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
