import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OnBoardingIllus3 extends StatelessWidget {
  const OnBoardingIllus3({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xff3D6FFF).withValues(alpha: 0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: -0.22,
            child: Transform.translate(
              offset: const Offset(-28, 8),
              child: _courseCard(
                label: 'Mathematics',
                icon: Icons.functions_rounded,
                topColor: const Color(0xff7C3AED),
                bottomColor: const Color(0xff3B0764),
                opacity: 0.52,
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.22,
            child: Transform.translate(
              offset: const Offset(28, 8),
              child: _courseCard(
                label: 'Physics',
                icon: Icons.science_rounded,
                topColor: const Color(0xff0EA5E9),
                bottomColor: const Color(0xff0C4A6E),
                opacity: 0.52,
              ),
            ),
          ),
          _courseCard(
            label: 'AI Systems',
            icon: Icons.psychology_rounded,
            topColor: const Color(0xff4A7AFF),
            bottomColor: const Color(0xff001E6B),
            opacity: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _courseCard({
    required String label,
    required IconData icon,
    required Color topColor,
    required Color bottomColor,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 148,
        height: 192,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topColor, bottomColor],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.11),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: topColor.withValues(alpha: opacity * 0.38),
              blurRadius: 22,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.13),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.90),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
