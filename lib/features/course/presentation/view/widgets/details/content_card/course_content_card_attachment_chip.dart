import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class CourseContentCardAttachmentChip extends StatelessWidget {
  final int count;
  const CourseContentCardAttachmentChip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.inputBgLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_file_rounded,
              size: 11, color: AppColors.textSecondary),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: AppTextStyles.overline.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
