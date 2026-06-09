import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/contact_model.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_nav_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/contact_us_sheet.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/help_faq_tile.dart';
import 'package:flutter/material.dart';

class ProfileHelpSection extends StatelessWidget {
  const ProfileHelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        ProfileSectionCard(
          title: l10n.faq,
          titleIcon: Icons.quiz_outlined,
          children: [
            HelpFaqTile(question: l10n.faqQuestion1, answer: l10n.faqAnswer1),
            HelpFaqTile(question: l10n.faqQuestion2, answer: l10n.faqAnswer2),
            HelpFaqTile(question: l10n.faqQuestion3, answer: l10n.faqAnswer3),
            HelpFaqTile(question: l10n.faqQuestion4, answer: l10n.faqAnswer4),
          ],
        ),
        ProfileSectionCard(
          title: l10n.support,
          titleIcon: Icons.headset_mic_outlined,
          children: [
            ProfileNavTile(
              icon: Icons.flag_outlined,
              iconColor: AppColors.error,
              iconBg: AppColors.errorLight,
              title: l10n.reportIssue,
              subtitle: l10n.reportIssueSubtitle,
              onTap: () => _openContactSheet(context, IssueType.technical),
            ),
          ],
        ),
      ],
    );
  }

  void _openContactSheet(BuildContext context, IssueType initialType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ContactUsSheet(initialType: initialType),
    );
  }
}
