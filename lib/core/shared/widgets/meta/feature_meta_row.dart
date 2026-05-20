import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class FeatureMetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color iconBgColor;
  final Color labelColor;
  final Color valueColor;

  const FeatureMetaRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.iconBgColor = const Color(0xffF1F5F9),
    this.labelColor = const Color(0xffA0AABB),
    this.valueColor = const Color(0xff1E293B),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: AppRadius.small,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        AppSpacing.w10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.overline.copyWith(
                  color: labelColor,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
