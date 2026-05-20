import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_display_data.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_tile.dart';

export 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_display_data.dart';

class AttachmentSectionCard extends StatelessWidget {
  final List<AttachmentDisplayData> attachments;
  final Color primaryColor;
  final Color countBgColor;

  const AttachmentSectionCard({
    super.key,
    required this.attachments,
    required this.primaryColor,
    this.countBgColor = const Color(0xffF0F4FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_file_rounded, size: 18, color: primaryColor),
              AppSpacing.w8,
              Text(
                'Attachments',
                style: AppTextStyles.titleSmall.copyWith(
                  color: const Color(0xff1E293B),
                ),
              ),
              AppSpacing.w6,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: countBgColor,
                  borderRadius: AppRadius.small,
                ),
                child: Text(
                  '${attachments.length}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h14,
          ...attachments.map((a) => AttachmentTile(
                attachment: a,
                primaryColor: primaryColor,
              )),
        ],
      ),
    );
  }
}
