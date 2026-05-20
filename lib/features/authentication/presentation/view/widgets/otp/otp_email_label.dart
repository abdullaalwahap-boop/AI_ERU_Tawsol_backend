import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OtpEmailLabel extends StatelessWidget {
  const OtpEmailLabel({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
          children: [
            const TextSpan(text: 'Enter the 6-digit code sent to\n'),
            TextSpan(
              text: email,
              style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
