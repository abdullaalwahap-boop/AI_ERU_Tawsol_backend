import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/reset_password/reset_password_form.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_gradient_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordViewBody extends StatelessWidget {
  const ResetPasswordViewBody({super.key, required this.resetToken});

  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        if (state is ResetPasswordSuccess) {
          return _SuccessContent();
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.h32,
              const AuthGradientTitle(
                text: 'Reset Password',
                fontSize: 28,
                textAlign: TextAlign.center,
              ),
              AppSpacing.h8,
              Text(
                'Create a strong new password',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
              ),
              AppSpacing.h32,
              ResetPasswordForm(resetToken: resetToken),
              AppSpacing.h32,
            ],
          ),
        );
      },
    );
  }
}

class _SuccessContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.2),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.accent,
                size: 40,
              ),
            ),
            AppSpacing.h24,
            const AuthGradientTitle(
              text: 'Password Reset!',
              fontSize: 26,
              textAlign: TextAlign.center,
            ),
            AppSpacing.h12,
            Text(
              'Your password has been successfully reset.\nYou can now sign in with your new password.',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h32,
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go(AppRouter.kLoginView),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.large,
                  ),
                ),
                child: Text(
                  'Back to Login',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
