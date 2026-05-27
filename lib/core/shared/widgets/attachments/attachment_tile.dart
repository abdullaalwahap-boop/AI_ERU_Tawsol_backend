import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/attachments/attachment_display_data.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/pages/image_viewer_page.dart';

enum _FileState { idle, downloading, done, error }

class AttachmentTile extends StatefulWidget {
  final AttachmentDisplayData attachment;
  final Color primaryColor;

  const AttachmentTile({
    super.key,
    required this.attachment,
    required this.primaryColor,
  });

  @override
  State<AttachmentTile> createState() => _AttachmentTileState();
}

class _AttachmentTileState extends State<AttachmentTile> {
  _FileState _state = _FileState.idle;
  double _progress = 0;
  String? _savedPath;

  AttachmentDisplayData get _a => widget.attachment;

  @override
  void initState() {
    super.initState();
    if (!_a.isImage) _checkAlreadyDownloaded();
  }

  Future<void> _checkAlreadyDownloaded() async {
    final url = _a.url;
    if (url == null || url.isEmpty) return;
    try {
      final dir = await getTemporaryDirectory();
      final name = _fileNameFromUrl(url);
      final path = '${dir.path}/$name';
      if (await File(path).exists()) {
        if (mounted) setState(() { _state = _FileState.done; _savedPath = path; });
      }
    } catch (_) {}
  }

  Future<void> _onTap() async {
    final url = _a.url;
    if (url == null || url.isEmpty) return;

    // Images → full-screen viewer
    if (_a.isImage) {
      await ImageViewerPage.open(context, imageUrl: url);
      return;
    }

    // Already downloaded → open immediately
    if (_state == _FileState.done && _savedPath != null) {
      await OpenFilex.open(_savedPath!);
      return;
    }

    if (_state == _FileState.downloading) return;
    setState(() { _state = _FileState.downloading; _progress = 0; });

    try {
      final dir = await getTemporaryDirectory();
      final name = _fileNameFromUrl(url);
      final savePath = '${dir.path}/$name';

      if (!await File(savePath).exists()) {
        await Dio().download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total > 0 && mounted) {
              setState(() => _progress = received / total);
            }
          },
        );
      }

      if (!mounted) return;
      setState(() { _state = _FileState.done; _savedPath = savePath; });
      await OpenFilex.open(savePath);
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = _FileState.error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Download failed'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _state = _FileState.idle);
    }
  }

  String _fileNameFromUrl(String url) {
    final name = url.split('/').last.split('?').first;
    return name.isNotEmpty ? name : 'file';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: _onTap,
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
                  color: _a.iconColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.small,
                ),
                child: Icon(_a.icon, size: 20, color: _a.iconColor),
              ),
              AppSpacing.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _a.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: const Color(0xff1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.h4,
                    Text(
                      _a.sizeLabel,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: const Color(0xffA0AABB),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.w8,
              _buildActionIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon() {
    final color = widget.primaryColor;

    if (_a.isImage) {
      return Icon(Icons.open_in_full_rounded, size: 18, color: color);
    }

    switch (_state) {
      case _FileState.downloading:
        return SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            value: _progress > 0 ? _progress : null,
            strokeWidth: 2.5,
            color: color,
          ),
        );
      case _FileState.done:
        return Icon(Icons.check_circle_rounded, size: 22, color: color);
      case _FileState.error:
        return Icon(Icons.error_rounded, size: 22, color: Colors.red.shade300);
      case _FileState.idle:
        return Icon(Icons.download_rounded, size: 18, color: color);
    }
  }
}
