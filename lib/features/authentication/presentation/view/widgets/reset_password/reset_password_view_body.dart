import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/reset_password/reset_password_form.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/reset_password/reset_password_success_content.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_gradient_title.dart';

class ResetPasswordViewBody extends StatelessWidget {
  const ResetPasswordViewBody({super.key, required this.resetToken});

  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        if (state is ResetPasswordSuccess) {
          return const ResetPasswordSuccessContent();
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.h32,
              AuthGradientTitle(
                text: AppLocalizations.of(context).resetPassword,
                fontSize: 28,
                textAlign: TextAlign.center,
              ),
              AppSpacing.h8,
              Text(
                AppLocalizations.of(context).createStrongPassword,
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
