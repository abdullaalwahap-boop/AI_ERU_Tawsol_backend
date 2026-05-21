import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_field.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_info_banner.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_requirements_panel.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  State<ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String _newPassword = '';

  bool get _hasMin8 => _newPassword.length >= 8;
  bool get _hasUpper => _newPassword.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _newPassword.contains(RegExp(r'[a-z]'));
  bool get _hasDigit => _newPassword.contains(RegExp(r'\d'));
  bool get _hasSpecial =>
      _newPassword.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Password changed successfully!',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
              margin: AppSpacing.pagePadding,
            ),
          );
        }
        if (state is ChangePasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
              margin: AppSpacing.pagePadding,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ChangePasswordInfoBanner(),
              AppSpacing.h24,
              ChangePasswordField(
                controller: _currentCtrl,
                label: 'Current Password',
                hint: 'Enter your current password',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              AppSpacing.h20,
              ChangePasswordField(
                controller: _newCtrl,
                label: 'New Password',
                hint: 'Create a strong password',
                onChanged: (v) => setState(() => _newPassword = v),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (!_hasMin8) return 'At least 8 characters required';
                  return null;
                },
              ),
              AppSpacing.h12,
              ChangePasswordRequirementsPanel(
                hasMin8: _hasMin8,
                hasUpper: _hasUpper,
                hasLower: _hasLower,
                hasDigit: _hasDigit,
                hasSpecial: _hasSpecial,
              ),
              AppSpacing.h20,
              ChangePasswordField(
                controller: _confirmCtrl,
                label: 'Confirm New Password',
                hint: 'Re-enter your new password',
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (v != _newCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
              AppSpacing.h32,
              ChangePasswordSubmitButton(onPressed: _submit),
              AppSpacing.h24,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    context.read<ChangePasswordCubit>().changePassword(
          currentPassword: _currentCtrl.text,
          newPassword: _newCtrl.text,
        );
  }
}
