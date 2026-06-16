import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

class ContentFileTypeChip extends StatelessWidget {
  final ContentFileType fileType;
  const ContentFileTypeChip({super.key, required this.fileType});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (fileType) {
      ContentFileType.pdf => ('PDF', const Color(0xffDC2626)),
      ContentFileType.doc => ('DOC', const Color(0xff2563EB)),
      ContentFileType.image => ('IMG', const Color(0xff059669)),
      ContentFileType.other => ('FILE', context.colorTextSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
