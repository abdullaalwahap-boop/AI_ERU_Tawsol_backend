import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/letter/letter_footer.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/letter/letter_header_strip.dart';

/// Generic "letter-style" card used in announcement and content details.
class LetterBodyCard extends StatelessWidget {
  final String body;
  final Color accentColor;
  final Color accentLightColor;
  final IconData accentIcon;
  final String? headerLabel;
  final String authorName;
  final String authorInitials;
  final String authorSubtitle;
  final bool isFromAdmin;

  const LetterBodyCard({
    super.key,
    required this.body,
    required this.accentColor,
    required this.accentLightColor,
    required this.accentIcon,
    this.headerLabel,
    required this.authorName,
    required this.authorInitials,
    required this.authorSubtitle,
    this.isFromAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LetterHeaderStrip(
            label: headerLabel ?? AppLocalizations.of(context).message,
            color: accentColor,
            lightColor: accentLightColor,
            icon: accentIcon,
          ),
          Container(height: 1, color: const Color(0xffE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              body,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xff1E293B),
                height: 1.75,
              ),
            ),
          ),
          Container(height: 1, color: const Color(0xffE2E8F0)),
          LetterFooter(
            authorName: authorName,
            authorInitials: authorInitials,
            subtitle: authorSubtitle,
            color: accentColor,
            lightColor: accentLightColor,
            isFromAdmin: isFromAdmin,
          ),
        ],
      ),
    );
  }
}
