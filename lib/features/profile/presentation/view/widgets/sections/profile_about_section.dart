import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/about/about_app_banner_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/about/about_info_row.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/about/about_mission_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/about/about_team_card.dart';
import 'package:flutter/material.dart';

class ProfileAboutSection extends StatelessWidget {
  const ProfileAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AboutAppBannerCard(),
        ProfileSectionCard(
          title: 'App Info',
          titleIcon: Icons.info_outline_rounded,
          children: [
            AboutInfoRow(
              icon: Icons.tag_rounded,
              iconColor: AppColors.contentGreen,
              iconBg: AppColors.contentGreenLight,
              label: 'Version',
              value: '1.0.0-beta',
            ),
            AboutInfoRow(
              icon: Icons.business_rounded,
              iconColor: AppColors.contentAmber,
              iconBg: AppColors.contentAmberLight,
              label: 'Organization',
              value: 'Egyptian Russian University',
            ),
            AboutInfoRow(
              icon: Icons.code_rounded,
              iconColor: AppColors.accent,
              iconBg: AppColors.accentLight.withValues(alpha: 0.13),
              label: 'Built with',
              value: 'Flutter + FastAPI',
            ),
            AboutInfoRow(
              icon: Icons.verified_rounded,
              iconColor: AppColors.contentPurple,
              iconBg: AppColors.contentPurpleLight,
              label: 'Release',
              value: 'May 2026',
            ),
          ],
        ),
        const AboutMissionCard(),
        const AboutTeamCard(),
      ],
    );
  }
}
