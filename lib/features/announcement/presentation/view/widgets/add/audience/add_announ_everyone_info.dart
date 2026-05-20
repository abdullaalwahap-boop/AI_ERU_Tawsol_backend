import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AddAnnounEveryoneInfo extends StatelessWidget {
  const AddAnnounEveryoneInfo({super.key});

  static const _green = Color(0xff059669);
  static const _greenBg = Color(0xffD1FAE5);
  static const _greenText = Color(0xff065F46);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: AppRadius.medium,
        border: Border.all(color: _green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.15),
              borderRadius: AppRadius.small,
            ),
            child: const Icon(Icons.public_rounded, size: 18, color: _green),
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(
              'Visible to all students across all departments',
              style: AppTextStyles.labelLarge.copyWith(
                color: _greenText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
