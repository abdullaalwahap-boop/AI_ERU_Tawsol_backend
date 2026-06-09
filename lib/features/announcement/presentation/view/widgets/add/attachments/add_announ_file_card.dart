import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/attachment_file_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';

class AddAnnounFileCard extends StatelessWidget {
  final AddAnnounAttachmentItem item;
  final VoidCallback onRemove;

  const AddAnnounFileCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: context.colorDivider, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLeading(),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.isLink ? _shortenUrl(item.url!) : item.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: item.isLink
                        ? const Color(0xff059669)
                        : context.colorTextPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.h2,
                Text(
                  item.sizeLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: context.colorTextHint,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.w8,
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xffFEE2E2),
                borderRadius: AppRadius.small,
              ),
              child: const Icon(Icons.close_rounded,
                  size: 14, color: Color(0xffDC2626)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading() {
    if (item.isImage && item.filePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(item.filePath!),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _iconBox(
            item.fileType.color,
            item.fileType.icon,
          ),
        ),
      );
    }

    if (item.isLink) {
      return _iconBox(const Color(0xff059669), Icons.link_rounded);
    }

    return _iconBox(item.fileType.color, item.fileType.icon);
  }

  Widget _iconBox(Color color, IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  String _shortenUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url;
    final host = uri.host.replaceFirst('www.', '');
    final path = uri.path.length > 20
        ? '${uri.path.substring(0, 20)}…'
        : uri.path;
    return path.isEmpty || path == '/' ? host : '$host$path';
  }
}
