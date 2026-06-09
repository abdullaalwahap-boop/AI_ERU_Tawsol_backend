import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';

class AnnounCardAttachmentChip extends StatelessWidget {
  final int count;

  const AnnounCardAttachmentChip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: context.colorInputBg,
        borderRadius: AppRadius.xxlarge,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.attach_file_rounded,
              size: 11, color: context.colorTextSecondary),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: AppTextStyles.badgeText.copyWith(
              color: context.colorTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
