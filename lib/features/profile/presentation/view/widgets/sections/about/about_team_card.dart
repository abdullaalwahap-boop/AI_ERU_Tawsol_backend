import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/about/about_team_member.dart';
import 'package:flutter/material.dart';

class AboutTeamCard extends StatelessWidget {
  const AboutTeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileSectionCard(
      title: 'Development Team',
      titleIcon: Icons.groups_rounded,
      children: [
        AboutTeamMember(name: 'Ziad Tamer', role: 'Flutter Developer'),
        AboutTeamMember(
            name: 'ERU CS Department', role: 'Backend & Architecture'),
      ],
    );
  }
}
