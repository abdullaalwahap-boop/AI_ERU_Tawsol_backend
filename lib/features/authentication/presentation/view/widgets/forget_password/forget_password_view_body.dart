import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/forget_password/forget_password_form.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_gradient_title.dart';
import 'package:flutter/material.dart';

class ForgetPasswordViewBody extends StatelessWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.h40,
          const Icon(
            Icons.lock_reset_rounded,
            color: AppColors.accent,
            size: 72,
          ),
          AppSpacing.h24,
          const AuthGradientTitle(
            text: 'Forgot Password?',
            fontSize: 28,
            textAlign: TextAlign.center,
          ),
          AppSpacing.h8,
          Text(
            "Enter your email and we'll send you a verification code",
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
          AppSpacing.h32,
          const ForgetPasswordForm(),
          AppSpacing.h32,
        ],
      ),
    );
  }
}
