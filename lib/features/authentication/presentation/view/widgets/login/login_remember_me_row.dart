import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/constants/auth_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
            activeColor: AuthColors.primary,
            side: const BorderSide(color: Colors.white38, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Remember me',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white60,
            fontSize: 13,
          ),
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
            style: GoogleFonts.plusJakartaSans(
              color: AuthColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
