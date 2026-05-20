import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class LetterFooter extends StatelessWidget {
  final String authorName;
  final String authorInitials;
  final String subtitle;
  final Color color;
  final Color lightColor;

  const LetterFooter({
    super.key,
    required this.authorName,
    required this.authorInitials,
    required this.subtitle,
    required this.color,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: AppRadius.small,
            ),
            child: Center(
              child: Text(
                authorInitials,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ),
          AppSpacing.w10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff1E293B),
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.labelSmall.copyWith(
                  color: const Color(0xffA0AABB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
