import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_container_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_list_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreferencesSection extends StatefulWidget {
  const PreferencesSection({super.key});

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return CustomContainerSection(
      title: 'Preferences',
      children: [
        CustomListTile(
          onTap: () {
            GoRouter.of(context).push(AppRouter.kThemeModeView);
          },
          icon: Icon(Icons.brightness_5_outlined, size: 36),
          title: 'Theme Mode',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(
                'Light',
                style: AppTextStyles.bodyLarge.copyWith(color: Color(0xff9E9D97)),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff9E9D97)),
            ],
          ),
        ),
        Divider(endIndent: 43, indent: 68.5, thickness: 0.5),
        CustomSwitchTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          value: isEnabled,
          onChanged: (value) {
            setState(() {
              isEnabled = value;
            });
          },
        ),
        Divider(endIndent: 43, indent: 68.5, thickness: 0.5),
        CustomListTile(
          onTap: () {
            GoRouter.of(context).push(AppRouter.kLanguageView);
          },
          icon: Icon(Icons.language_rounded, size: 36),
          title: 'Language',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(
                'English',
                style: AppTextStyles.bodyLarge.copyWith(color: Color(0xff9E9D97)),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff9E9D97)),
            ],
          ),
        ),
      ],
    );
  }
}
