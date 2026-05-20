import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AdditionalPagesAppBar extends StatelessWidget {
  const AdditionalPagesAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(backgroundColor: Colors.white),
        Text(title, style: AppTextStyles.heading2),
      ],
    );
  }
}
