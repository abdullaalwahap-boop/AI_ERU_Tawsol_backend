import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/attachments/picker/add_announ_link_input_dialog.dart';

class AddAnnounAttachPickerSheet extends StatelessWidget {
  final void Function(AddAnnounAttachmentItem) onPick;

  const AddAnnounAttachPickerSheet({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: AppRadius.xxxlarge,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorDivider,
                  borderRadius: AppRadius.xsmall,
                ),
              ),
              AppSpacing.h16,
              Text(
                'Attach a file',
                style: AppTextStyles.titleLarge
                    .copyWith(color: context.colorTextPrimary),
              ),
              AppSpacing.h20,
              Row(
                children: [
                  Expanded(
                    child: _PickTile(
                      icon: Icons.image_rounded,
                      label: 'Gallery',
                      color: const Color(0xff7C3AED),
                      onTap: () => _pickGallery(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PickTile(
                      icon: Icons.insert_drive_file_rounded,
                      label: 'Document',
                      color: const Color(0xff2563EB),
                      onTap: () => _pickDocument(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PickTile(
                      icon: Icons.link_rounded,
                      label: 'Link',
                      color: const Color(0xff059669),
                      onTap: () => _pickLink(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickGallery(BuildContext context) async {
    Navigator.pop(context);
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    final bytes = await File(picked.path).length();
    final sizeMB = bytes / (1024 * 1024);

    onPick(AddAnnounAttachmentItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: picked.name,
      sizeLabel: '${sizeMB.toStringAsFixed(1)} MB',
      fileType: AttachmentFileType.image,
      filePath: picked.path,
    ));
  }

  Future<void> _pickDocument(BuildContext context) async {
    Navigator.pop(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'doc', 'docx', 'ppt', 'pptx',
        'xls', 'xlsx', 'txt', 'zip', 'rar',
      ],
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final sizeMB = file.size / (1024 * 1024);
    final ext = file.extension?.toLowerCase() ?? '';

    onPick(AddAnnounAttachmentItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: file.name,
      sizeLabel: '${sizeMB.toStringAsFixed(1)} MB',
      fileType: _fileTypeFromExt(ext),
      filePath: file.path,
    ));
  }

  Future<void> _pickLink(BuildContext context) async {
    Navigator.pop(context);
    if (!context.mounted) return;

    final url = await showDialog<String>(
      context: context,
      builder: (_) => const AddAnnounLinkInputDialog(),
    );
    if (url == null || url.isEmpty) return;

    onPick(AddAnnounAttachmentItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: url,
      sizeLabel: 'Link',
      fileType: AttachmentFileType.other,
      url: url,
    ));
  }

  static AttachmentFileType _fileTypeFromExt(String ext) {
    if (ext == 'pdf') return AttachmentFileType.pdf;
    if (['doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'].contains(ext)) {
      return AttachmentFileType.doc;
    }
    return AttachmentFileType.other;
  }
}

class _PickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PickTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: AppRadius.large,
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppRadius.medium,
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
