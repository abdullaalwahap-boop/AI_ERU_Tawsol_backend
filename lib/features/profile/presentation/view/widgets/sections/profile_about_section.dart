import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const AboutAppBannerCard(),
        ProfileSectionCard(
          title: l10n.appInfo,
          titleIcon: Icons.info_outline_rounded,
          children: [
            AboutInfoRow(
              icon: Icons.tag_rounded,
              iconColor: AppColors.contentGreen,
              iconBg: AppColors.contentGreenLight,
              label: l10n.version,
              value: l10n.versionValue,
            ),
            AboutInfoRow(
              icon: Icons.business_rounded,
              iconColor: AppColors.contentAmber,
              iconBg: AppColors.contentAmberLight,
              label: l10n.organization,
              value: l10n.organizationValue,
            ),
            AboutInfoRow(
              icon: Icons.code_rounded,
              iconColor: AppColors.accent,
              iconBg: AppColors.accentLight.withValues(alpha: 0.13),
              label: l10n.builtWith,
              value: l10n.builtWithValue,
            ),
            AboutInfoRow(
              icon: Icons.verified_rounded,
              iconColor: AppColors.contentPurple,
              iconBg: AppColors.contentPurpleLight,
              label: l10n.releaseLabel,
              value: l10n.releaseValue,
            ),
          ],
        ),
        const AboutMissionCard(),
        const AboutTeamCard(),
      ],
    );
  }
}
