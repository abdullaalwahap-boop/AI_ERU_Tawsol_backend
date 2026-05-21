import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_nav_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/help_faq_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/help_report_sheet.dart';
import 'package:flutter/material.dart';

class ProfileHelpSection extends StatelessWidget {
  const ProfileHelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileSectionCard(
          title: 'FAQ',
          titleIcon: Icons.quiz_outlined,
          children: const [
            HelpFaqTile(
              question: 'How do I reset my password?',
              answer:
                  'Go to Account → Change Password. You\'ll need your current password. If you\'ve forgotten it, use Forgot Password on the login screen.',
            ),
            HelpFaqTile(
              question: 'How are announcements filtered?',
              answer:
                  'Announcements are filtered by your role, level, and enrolled courses. Use the filter chips on the home screen to narrow down by type.',
            ),
            HelpFaqTile(
              question: 'Can I submit assignments here?',
              answer:
                  'Yes — open the relevant course, navigate to the assignment card, and tap Submit. Accepted formats: PDF, Word, ZIP.',
            ),
            HelpFaqTile(
              question: 'Who can see my messages?',
              answer:
                  'Direct messages are private between you and the recipient. Group channels are visible to all enrolled members of that course.',
            ),
          ],
        ),
        ProfileSectionCard(
          title: 'Support',
          titleIcon: Icons.headset_mic_outlined,
          children: [
            ProfileNavTile(
              icon: Icons.mail_outline_rounded,
              iconColor: AppColors.accent,
              iconBg: AppColors.accentLight.withValues(alpha: 0.13),
              title: 'Contact Us',
              subtitle: 'support@eru.edu.eg',
              onTap: () => _launchEmail(context),
            ),
            ProfileNavTile(
              icon: Icons.flag_outlined,
              iconColor: AppColors.error,
              iconBg: AppColors.errorLight,
              title: 'Report an Issue',
              subtitle: 'Something broken? Tell us',
              onTap: () => _showReportSheet(context),
            ),
          ],
        ),
      ],
    );
  }

  void _launchEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening email client…',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        margin: AppSpacing.pagePadding,
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const HelpReportSheet(),
    );
  }
}
