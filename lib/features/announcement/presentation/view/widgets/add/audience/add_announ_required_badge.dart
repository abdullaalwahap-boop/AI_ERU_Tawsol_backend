import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AddAnnounRequiredBadge extends StatelessWidget {
  const AddAnnounRequiredBadge({super.key});

  static const _amber = Color(0xffF59E0B);
  static const _amberBg = Color(0xffFEF3C7);
  static const _amberText = Color(0xffD97706);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _amberBg,
        borderRadius: AppRadius.small,
        border: Border.all(color: _amber.withValues(alpha: 0.4)),
      ),
      child: Text(
        AppLocalizations.of(context).required,
        style: AppTextStyles.overline.copyWith(
          color: _amberText,
        ),
      ),
    );
  }
}
