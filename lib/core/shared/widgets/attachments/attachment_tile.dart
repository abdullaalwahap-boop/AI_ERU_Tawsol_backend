import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_display_data.dart';

class AttachmentTile extends StatelessWidget {
  final AttachmentDisplayData attachment;
  final Color primaryColor;

  const AttachmentTile({
    super.key,
    required this.attachment,
    required this.primaryColor,
  });

  Future<void> _open() async {
    final raw = attachment.url;
    if (raw == null || raw.isEmpty) return;
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = attachment.url != null && attachment.url!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: hasUrl ? _open : null,
        borderRadius: AppRadius.medium,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xffF1F5F9),
            borderRadius: AppRadius.medium,
            border: Border.all(color: const Color(0xffE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: attachment.iconColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.small,
                ),
                child: Icon(attachment.icon, size: 20,
                    color: attachment.iconColor),
              ),
              AppSpacing.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: const Color(0xff1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.h4,
                    Text(
                      attachment.sizeLabel,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: const Color(0xffA0AABB),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: AppRadius.small,
                ),
                child: Icon(
                  hasUrl
                      ? Icons.open_in_new_rounded
                      : Icons.download_rounded,
                  size: 18,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
