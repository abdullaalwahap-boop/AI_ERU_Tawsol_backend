import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/about/about_team_member.dart';
import 'package:flutter/material.dart';

class AboutTeamCard extends StatelessWidget {
  const AboutTeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ProfileSectionCard(
      title: l10n.developmentTeam,
      titleIcon: Icons.groups_rounded,
      children: [
        AboutTeamMember(name: 'Ziad Tamer', role: l10n.flutterDeveloper),
        AboutTeamMember(name: 'ERU CS Department', role: l10n.backendArchitecture),
      ],
    );
  }
}
