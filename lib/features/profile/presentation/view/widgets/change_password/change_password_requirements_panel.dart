import 'package:ai_eru_tawasol/core/design/app_radius.dart';
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
        color: AppColors.inputBgLight,
        borderRadius: AppRadius.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.h8,
          PasswordRequirementItem(label: 'At least 8 characters', met: hasMin8),
          PasswordRequirementItem(
              label: 'One uppercase letter (A–Z)', met: hasUpper),
          PasswordRequirementItem(
              label: 'One lowercase letter (a–z)', met: hasLower),
          PasswordRequirementItem(label: 'One number (0–9)', met: hasDigit),
          PasswordRequirementItem(
              label: 'One special character (!@#…)', met: hasSpecial),
        ],
      ),
    );
  }
}
