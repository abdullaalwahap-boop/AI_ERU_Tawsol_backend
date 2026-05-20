import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OnBoardingIllus2 extends StatelessWidget {
  const OnBoardingIllus2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 250,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 40,
            child: Container(
              width: 230,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff3D6FFF).withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            child: _card(
              priority: const Color(0xffFF4757),
              icon: Icons.priority_high_rounded,
              label: 'Urgent — Exam Reschedule',
              opacity: 0.48,
              scale: 0.88,
            ),
          ),
          Positioned(
            top: 50,
            child: _card(
              priority: const Color(0xffFFA502),
              icon: Icons.campaign_rounded,
              label: 'Important — Lab Cancelled',
              opacity: 0.68,
              scale: 0.94,
            ),
          ),
          Positioned(
            top: 22,
            child: _card(
              priority: const Color(0xff3D6FFF),
              icon: Icons.notifications_rounded,
              label: 'Announcement — New Lecture',
              opacity: 1.0,
              scale: 1.0,
            ),
          ),
          Positioned(
            top: 0,
            right: 40,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff4A7AFF), Color(0xff001E6B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff3D6FFF).withValues(alpha: 0.52),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.16),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                size: 22,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required Color priority,
    required IconData icon,
    required String label,
    required double opacity,
    required double scale,
  }) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 248,
          height: 62,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xff0C1B3A).withValues(alpha: 0.96),
                const Color(0xff071230).withValues(alpha: 0.92),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.09),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: priority,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Icon(icon, size: 18, color: priority),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
