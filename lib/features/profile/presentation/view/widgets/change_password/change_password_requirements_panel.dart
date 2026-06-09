import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/password_requirement_item.dart';
import 'package:flutter/material.dart';

class ChangePasswordRequirementsPanel extends StatelessWidget {
  final bool hasMin8;
  final bool hasUpper;
  final bool hasLower;
  final bool hasDigit;
  final bool hasSpecial;

  const ChangePasswordRequirementsPanel({
    super.key,
    required this.hasMin8,
    required this.hasUpper,
    required this.hasLower,
    required this.hasDigit,
    required this.hasSpecial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorInputBg,
        borderRadius: AppRadius.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).passwordRequirements,
            style: AppTextStyles.labelSmall.copyWith(
              color: context.colorTextSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.h8,
          PasswordRequirementItem(label: AppLocalizations.of(context).atLeast8Chars, met: hasMin8),
          PasswordRequirementItem(label: AppLocalizations.of(context).oneUppercaseLetter, met: hasUpper),
          PasswordRequirementItem(label: AppLocalizations.of(context).oneLowercaseLetter, met: hasLower),
          PasswordRequirementItem(label: AppLocalizations.of(context).oneNumber, met: hasDigit),
          PasswordRequirementItem(label: AppLocalizations.of(context).oneSpecialChar, met: hasSpecial),
        ],
      ),
    );
  }
}
