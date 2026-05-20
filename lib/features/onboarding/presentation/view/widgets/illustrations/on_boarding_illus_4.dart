import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OnBoardingIllus4 extends StatelessWidget {
  const OnBoardingIllus4({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xff3D6FFF).withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 16,
            child: _bubble(
              text: 'Assignment due\ntomorrow at 11 PM',
              fromColor: const Color(0xff3D6FFF),
              toColor: const Color(0xff1A4FEE),
              isRight: true,
            ),
          ),
          Positioned(
            top: 108,
            left: 16,
            child: _bubble(
              text: 'Understood, thank\nyou Doctor!',
              fromColor: const Color(0xff0D1F3C),
              toColor: const Color(0xff091526),
              isRight: false,
              hasBorder: true,
            ),
          ),
          Positioned(
            bottom: 8,
            left: 20,
            child: _typingDots(),
          ),
        ],
      ),
    );
  }

  Widget _bubble({
    required String text,
    required Color fromColor,
    required Color toColor,
    required bool isRight,
    bool hasBorder = false,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 188),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [fromColor, toColor],
        ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isRight ? 16 : 4),
          bottomRight: Radius.circular(isRight ? 4 : 16),
        ),
        border: hasBorder
            ? Border.all(
                color: Colors.white.withValues(alpha: 0.09),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: fromColor.withValues(alpha: 0.30),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: Colors.white.withValues(alpha: 0.88),
          height: 1.55,
        ),
      ),
    );
  }

  Widget _typingDots() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xff0D1F3C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff4A7AFF).withValues(alpha: 0.75),
            ),
          ),
        ),
      ),
    );
  }
}
