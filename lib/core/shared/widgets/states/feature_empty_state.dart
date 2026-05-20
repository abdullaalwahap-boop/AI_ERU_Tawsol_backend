import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class FeatureEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final Color iconBgColor;

  const FeatureEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    this.iconBgColor = const Color(0xffF0F4FF),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
              child: Icon(icon, size: 40, color: accentColor),
            ),
            AppSpacing.h20,
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: const Color(0xff1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xff64748B),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
