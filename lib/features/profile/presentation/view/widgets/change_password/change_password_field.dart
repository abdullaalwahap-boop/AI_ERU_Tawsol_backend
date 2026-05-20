import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ChangePasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const ChangePasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.validator,
  });

  @override
  State<ChangePasswordField> createState() => _ChangePasswordFieldState();
}

class _ChangePasswordFieldState extends State<ChangePasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.h6,
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.inputBgLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.large,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.large,
              borderSide: BorderSide(
                color: AppColors.borderLight,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.large,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.large,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.large,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
      ],
    );
  }
}
