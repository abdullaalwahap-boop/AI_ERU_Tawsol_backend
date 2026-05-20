import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomAboutMeHeader extends StatelessWidget {
  const CustomAboutMeHeader({
    super.key,
    required this.image,
    required this.title,
    this.subTitile,
    required this.paragraph,
  });

  final Widget image;
  final String title;
  final String? subTitile;
  final String paragraph;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        image,
        AppSpacing.h10,
        Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 28)),
        if (subTitile != null)
          Text(
            subTitile!,
            style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
          ),
        AppSpacing.h10,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            paragraph,
            style: AppTextStyles.heading4.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
