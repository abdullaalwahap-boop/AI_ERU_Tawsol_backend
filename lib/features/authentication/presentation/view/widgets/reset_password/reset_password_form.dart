import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/helpers/auth_validators.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<ResetPasswordCubit>().resetPassword(
          email: widget.email,
          newPassword: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AuthTextField(
            controller: _passwordCtrl,
            label: 'New Password',
            prefixIcon: Icons.lock_outline_rounded,
            obscurable: true,
            textInputAction: TextInputAction.next,
            validator: AuthValidators.password,
          ),
          AppSpacing.h16,
          AuthTextField(
            controller: _confirmCtrl,
            label: 'Confirm Password',
            prefixIcon: Icons.lock_outline_rounded,
            obscurable: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: AuthValidators.confirmPassword(_passwordCtrl),
          ),
          AppSpacing.h24,
          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            builder: (context, state) {
              final isLoading = state is ResetPasswordLoading;
              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.large,
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          'Reset Password',
                          style: AppTextStyles.buttonLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
