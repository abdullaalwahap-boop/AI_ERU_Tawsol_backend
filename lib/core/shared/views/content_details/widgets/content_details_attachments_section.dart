import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_section_card.dart';

class ContentDetailsAttachmentsSection extends StatelessWidget {
  final List<ContentDisplayAttachment> attachments;

  const ContentDetailsAttachmentsSection({
    super.key,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return AttachmentSectionCard(
      primaryColor: AppColors.primary,
      attachments: attachments
          .map((a) => AttachmentDisplayData(
                name: a.name,
                sizeLabel: a.sizeLabel,
                icon: a.icon,
                iconColor: a.iconColor,
                url: a.url,
                isImage: a.isImage,
              ))
          .toList(),
    );
  }
}
