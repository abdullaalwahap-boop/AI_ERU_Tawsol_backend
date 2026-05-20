import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/additional_pages_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_message.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/language_options.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/settings_option_tile.dart';
import 'package:flutter/material.dart';

class LanguageViewBody extends StatefulWidget {
  const LanguageViewBody({super.key});

  @override
  State<LanguageViewBody> createState() => _LanguageViewBodyState();
}

class _LanguageViewBodyState extends State<LanguageViewBody> {
  LanguageOptions selectedMode = LanguageOptions.english;

  void selectMode(LanguageOptions mode) {
    setState(() {
      selectedMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdditionalPagesAppBar(title: 'Language'),
        AppSpacing.h40,
        SettingsOptionTile<LanguageOptions>(
          title: 'English',
          subtitle: 'English',
          value: LanguageOptions.english,
          groupValue: selectedMode,
          onTap: () => selectMode(LanguageOptions.english),
        ),
        AppSpacing.h20,
        SettingsOptionTile<LanguageOptions>(
          title: 'العربية',
          subtitle: 'Arabic',
          value: LanguageOptions.arabic,
          groupValue: selectedMode,
          onTap: () => selectMode(LanguageOptions.arabic),
        ),
        Spacer(flex: 10),
        CustomMessage(
          text: 'The app will restart to apply the new language.',
          icon: Icon(Icons.language, color: Colors.blue, size: 36),
        ),
        Spacer(),
      ],
    );
  }
}
