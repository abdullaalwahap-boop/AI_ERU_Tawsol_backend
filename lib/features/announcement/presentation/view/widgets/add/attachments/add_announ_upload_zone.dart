import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';

class AddAnnounUploadZone extends StatelessWidget {
  final VoidCallback onTap;

  const AddAnnounUploadZone({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.03),
          borderRadius: AppRadius.large,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: AppRadius.large,
              ),
              child: const Icon(Icons.attach_file_rounded,
                  size: 22, color: AppColors.primary),
            ),
            AppSpacing.h10,
            Text(
              'Tap to attach files',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: context.colorTextPrimary,
              ),
            ),
            AppSpacing.h4,
            Text(
              'PDF · DOCX · PPT · Images · ZIP · Links',
              style: AppTextStyles.labelSmall.copyWith(
                color: context.colorTextHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
