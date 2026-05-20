import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginRememberMeRow extends StatelessWidget {
  const LoginRememberMeRow({
    super.key,
    required this.rememberMe,
    required this.onChanged,
  });

  final bool rememberMe;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: rememberMe,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: AppColors.accent,
            side: const BorderSide(color: Colors.white38, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.xsmall,
            ),
          ),
        ),
        AppSpacing.w8,
        Text(
          'Remember me',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => context.push(AppRouter.kForgetPasswordView),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Forgot Password?',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent),
          ),
        ),
      ],
    );
  }
}
