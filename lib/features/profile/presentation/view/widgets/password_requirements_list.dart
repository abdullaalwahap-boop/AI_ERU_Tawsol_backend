import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/password_requirements.dart';
import 'package:flutter/material.dart';

class PasswordRequirementsList extends StatelessWidget {
  const PasswordRequirementsList({
    super.key,
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasUpperCase,
    required this.isMatch,
  });

  final bool hasMinLength;
  final bool hasNumber;
  final bool hasUpperCase;
  final bool isMatch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordRequirements(
          text: 'At least 8 characters',
          isValid: hasMinLength,
        ),
        AppSpacing.h8,
        PasswordRequirements(text: 'Contains a number', isValid: hasNumber),
        AppSpacing.h8,
        PasswordRequirements(
          text: 'Contains uppercase letter',
          isValid: hasUpperCase,
        ),
        AppSpacing.h8,
        PasswordRequirements(text: 'Passwords match', isValid: isMatch),
      ],
    );
  }
}
