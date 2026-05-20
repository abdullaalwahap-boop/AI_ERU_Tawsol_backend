import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class SplashAppName extends StatelessWidget {
  const SplashAppName({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppColors.accentGradientEnd],
          ).createShader(bounds),
          child: Text(
            'AI Connect',
            style: AppTextStyles.display.copyWith(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
        AppSpacing.h12,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.accent.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            AppSpacing.w10,
            Text(
              'SMART CAMPUS · ERU',
              style: AppTextStyles.overline.copyWith(
                fontSize: 10.5,
                color: Colors.white.withValues(alpha: 0.50),
                letterSpacing: 2.4,
              ),
            ),
            AppSpacing.w10,
            Container(
              width: 28,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
