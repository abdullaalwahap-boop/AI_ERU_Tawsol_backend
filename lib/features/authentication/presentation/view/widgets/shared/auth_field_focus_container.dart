import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthFieldFocusContainer extends StatelessWidget {
  const AuthFieldFocusContainer({
    super.key,
    required this.isFocused,
    required this.child,
  });

  final bool isFocused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: AppRadius.medium,
        color: AppColors.fieldDark,
        border: Border.all(
          color: isFocused
              ? AppColors.accent.withValues(alpha: 0.65)
              : AppColors.accentSoft.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: child,
    );
  }
}
