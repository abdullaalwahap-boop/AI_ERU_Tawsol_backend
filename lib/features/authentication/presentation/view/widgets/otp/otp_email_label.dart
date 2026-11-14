import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OtpEmailLabel extends StatelessWidget {
  const OtpEmailLabel({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        textAlign: TextAlign.center,
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        text: TextSpan(
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54, letterSpacing: 0.0),
          children: [
            TextSpan(
              text: isAr
                  ? 'أدخل الرمز المكون من 6 أرقام المرسل إلى\n'
                  : 'Enter the 6-digit code sent to\n',
              style: const TextStyle(letterSpacing: 0.0),
            ),
            TextSpan(
              text: email,
              style: AppTextStyles.titleSmall.copyWith(color: Colors.white, letterSpacing: 0.0),
            ),
          ],
        ),
      ),
    );
  }
}
