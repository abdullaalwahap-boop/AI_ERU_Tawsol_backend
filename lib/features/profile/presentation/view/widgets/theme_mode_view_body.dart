import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/additional_pages_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_message.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/theme_mode_options.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/settings_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThemeModeViewBody extends StatefulWidget {
  const ThemeModeViewBody({super.key});

  @override
  State<ThemeModeViewBody> createState() => _ThemeModeViewBodyState();
}

class _ThemeModeViewBodyState extends State<ThemeModeViewBody> {
  ThemeModeOptions selectedMode = ThemeModeOptions.light;

  void selectMode(ThemeModeOptions mode) {
    setState(() {
      selectedMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdditionalPagesAppBar(title: 'Theme Mode'),
        AppSpacing.h40,
        SettingsOptionTile<ThemeModeOptions>(
          icon: Icons.wb_sunny_outlined,
          title: 'Light',
          value: ThemeModeOptions.light,
          groupValue: selectedMode,
          onTap: () => selectMode(ThemeModeOptions.light),
        ),
        AppSpacing.h20,
        SettingsOptionTile<ThemeModeOptions>(
          icon: Icons.nights_stay_outlined,
          title: 'Dark',
          value: ThemeModeOptions.dark,
          groupValue: selectedMode,
          onTap: () => selectMode(ThemeModeOptions.dark),
        ),
        AppSpacing.h20,
        SettingsOptionTile(
          icon: Icons.phone_iphone_sharp,
          title: 'System Default',
          value: ThemeModeOptions.system,
          groupValue: selectedMode,
          onTap: () => selectMode(ThemeModeOptions.system),
        ),
        Spacer(flex: 10),
        CustomMessage(
          text: 'System Default will match your device settings.',
          icon: FaIcon(FontAwesomeIcons.gear, color: Colors.blue, size: 36),
        ),
        Spacer(),
      ],
    );
  }
}
