import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/login/login_illustration.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_gradient_title.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.h36,
        const LoginIllustration(),
        AppSpacing.h32,
        const AuthGradientTitle(
          text: 'Welcome Back',
          fontSize: 30,
          letterSpacing: -0.5,
          textAlign: TextAlign.center,
        ),
        AppSpacing.h8,
        Text(
          'Sign in with your university account',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
          textAlign: TextAlign.center,
        ),
        AppSpacing.h32,
      ],
    );
  }
}
