import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_attachment_tile.dart';

class AnnounDetailsAttachments extends StatelessWidget {
  final List<AnnounAttachment> attachments;

  const AnnounDetailsAttachments({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_file_rounded,
                  size: 18, color: AppColors.primary),
              AppSpacing.w8,
              Text(
                AppLocalizations.of(context).attachments,
                style: AppTextStyles.titleSmall.copyWith(
                  color: context.colorTextPrimary,
                ),
              ),
              AppSpacing.w6,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colorBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${attachments.length}',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h14,
          ...attachments.map((a) => AnnounDetailsAttachmentTile(attachment: a)),
        ],
      ),
    );
  }
}
