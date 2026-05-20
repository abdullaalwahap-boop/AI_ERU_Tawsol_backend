import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnBoardingPageIndicator extends StatelessWidget {
  const OnBoardingPageIndicator({
    super.key,
    required this.count,
    required this.current,
  });

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3.5),
          width: isActive ? 22.0 : 7.0,
          height: 7.0,
          decoration: BoxDecoration(
            borderRadius: AppRadius.xsmall,
            gradient: isActive
                ? const LinearGradient(
                    colors: [AppColors.accentLight, AppColors.accent],
                  )
                : null,
            color: isActive ? null : Colors.white.withValues(alpha: 0.22),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.50),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
