import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoginCardBottomStrip extends StatelessWidget {
  const LoginCardBottomStrip({
    super.key,
    required this.height,
    required this.cardWidth,
  });

  final double height;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final hPad = cardWidth * 0.053;
    final largeFontSize = (cardWidth * 0.037).clamp(9.0, 13.0);
    final smallFontSize = (cardWidth * 0.030).clamp(7.0, 10.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'AI CONNECT',
            style: AppTextStyles.buttonSmall.copyWith(
              color: Colors.white,
              fontSize: largeFontSize,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'SMART CAMPUS · ERU',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white54,
              fontSize: smallFontSize,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
