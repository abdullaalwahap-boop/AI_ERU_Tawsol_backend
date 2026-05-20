import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundDark1,
                AppColors.backgroundDark2,
                AppColors.primaryDark,
                AppColors.backgroundDark4,
              ],
              stops: [0.0, 0.35, 0.70, 1.0],
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.5 - size.width * 0.55,
          child: Container(
            width: size.width * 1.1,
            height: size.width * 1.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.13),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -size.width * 0.2,
          right: -size.width * 0.1,
          child: Container(
            width: size.width * 0.72,
            height: size.width * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentSoft.withValues(alpha: 0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -size.width * 0.15,
          left: -size.width * 0.1,
          child: Container(
            width: size.width * 0.65,
            height: size.width * 0.65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
