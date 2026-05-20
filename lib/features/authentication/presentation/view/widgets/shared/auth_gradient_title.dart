import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthGradientTitle extends StatelessWidget {
  const AuthGradientTitle({
    super.key,
    required this.text,
    this.fontSize = 26,
    this.letterSpacing = -0.4,
    this.textAlign,
  });

  final String text;
  final double fontSize;
  final double letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, AppColors.accentGradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: AppTextStyles.heading1.copyWith(
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          color: Colors.white,
        ),
      ),
    );
  }
}
