import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileEditNameDialog extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSave;

  const ProfileEditNameDialog({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colorSurface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlarge),
      title: Text(
        'Edit Name',
        style: AppTextStyles.heading4.copyWith(color: context.colorTextPrimary),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: AppTextStyles.bodyMedium.copyWith(color: context.colorTextPrimary),
        decoration: InputDecoration(
          hintText: 'Enter your full name',
          hintStyle:
              AppTextStyles.bodyMedium.copyWith(color: context.colorTextHint),
          filled: true,
          fillColor: context.colorInputBg,
          border: OutlineInputBorder(
            borderRadius: AppRadius.large,
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonSmall
                .copyWith(color: context.colorTextSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) onSave(name);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            elevation: 0,
          ),
          child: Text(
            'Save',
            style: AppTextStyles.buttonSmall
                .copyWith(color: AppColors.textOnPrimary),
          ),
        ),
      ],
    );
  }
}
