import 'dart:io';

import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

enum _DownloadState { idle, downloading, done, error }

class MessageFileContent extends StatefulWidget {
  final ChatMessage message;

  const MessageFileContent({super.key, required this.message});

  @override
  State<MessageFileContent> createState() => _MessageFileContentState();
}

class _MessageFileContentState extends State<MessageFileContent> {
  _DownloadState _state = _DownloadState.idle;
  double _progress = 0;
  String? _savedPath;

  ChatMessage get _msg => widget.message;

  @override
  void initState() {
    super.initState();
    _checkAlreadyDownloaded();
  }

  // ── Check if file already downloaded from a previous session ──────────────

  Future<void> _checkAlreadyDownloaded() async {
    final fn = _msg.fileName;
    if (fn == null) return;
    try {
      final dir = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$fn';
      if (await File(path).exists()) {
        if (mounted) {
          setState(() {
            _state = _DownloadState.done;
            _savedPath = path;
          });
        }
      }
    } catch (_) {}
  }

  // ── URL resolution ─────────────────────────────────────────────────────────

  bool get _isLocalFile =>
      _msg.fileUrl != null &&
      !_msg.fileUrl!.startsWith('/') &&
      !_msg.fileUrl!.startsWith('http');

  String? get _remoteUrl {
    final url = _msg.fileUrl;
    if (url == null) return null;
    if (url.startsWith('/')) return '${ApiConstants.baseUrl}$url';
    if (url.startsWith('http')) return url;
    return null;
  }

  // ── Download ───────────────────────────────────────────────────────────────

  Future<void> _download() async {
    if (_state == _DownloadState.downloading) return;

    // Sent by me — open directly if local, or download to temp then open.
    if (_msg.isFromMe) {
      if (_isLocalFile && _msg.fileUrl != null) {
        await OpenFilex.open(_msg.fileUrl!);
      } else {
        await _downloadAndOpen(toTemp: true);
      }
      return;
    }

    if (_state == _DownloadState.done && _savedPath != null) {
      await OpenFilex.open(_savedPath!);
      return;
    }

    if (_isLocalFile) {
      await OpenFilex.open(_msg.fileUrl!);
      return;
    }

    final url = _remoteUrl;
    if (url == null) return;

    setState(() {
      _state = _DownloadState.downloading;
      _progress = 0;
    });

    try {
      final dir = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final fileName = _msg.fileName ?? _urlFileName(url);
      final savePath = '${dir.path}/$fileName';

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _progress = received / total);
          }
        },
      );

      if (!mounted) return;
      setState(() {
        _state = _DownloadState.done;
        _savedPath = savePath;
      });

      await OpenFilex.open(savePath);
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = _DownloadState.error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Download failed'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _state = _DownloadState.idle);
    }
  }

  /// Downloads the file to a temp directory and opens it.
  /// Used for sent messages (no download state shown).
  Future<void> _downloadAndOpen({required bool toTemp}) async {
    final url = _remoteUrl;
    if (url == null) return;
    try {
      final dir = toTemp
          ? await getTemporaryDirectory()
          : (await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory());
      final fileName = _msg.fileName ?? _urlFileName(url);
      final savePath = '${dir.path}/$fileName';
      if (!await File(savePath).exists()) {
        await Dio().download(url, savePath);
      }
      await OpenFilex.open(savePath);
      if (!toTemp) {
        if (mounted) setState(() { _state = _DownloadState.done; _savedPath = savePath; });
      }
    } catch (_) {}
  }

  String _urlFileName(String url) {
    final name = url.split('/').last.split('?').first;
    return name.isNotEmpty ? name : 'file';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isMe = _msg.isFromMe;
    final fileName = _msg.fileName ?? 'Document';
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'FILE';
    final sizeText = _msg.fileSizeMB != null
        ? '${_msg.fileSizeMB!.toStringAsFixed(1)} MB'
        : '';

    return GestureDetector(
      onTap: _download,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── File type icon ───────────────────────────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.18)
                    : _colorForExt(ext).withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.3)
                      : _colorForExt(ext).withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconForExt(ext),
                    color: isMe ? Colors.white : _colorForExt(ext),
                    size: 20,
                  ),
                  Text(
                    ext,
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                      color: isMe ? Colors.white : _colorForExt(ext),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.w10,

            // ── File name + size ─────────────────────────────────────────────
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isMe
                          ? AppColors.sentBubbleText
                          : context.colorTextPrimary,
                    ),
                  ),
                  if (sizeText.isNotEmpty) ...[
                    AppSpacing.h2,
                    Text(
                      sizeText,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isMe
                            ? Colors.white.withValues(alpha: 0.7)
                            : context.colorTextSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            AppSpacing.w8,

            // ── Action button (only for received messages) ───────────────────
            if (!isMe) _buildActionIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon() {
    const color = AppColors.primary;

    switch (_state) {
      case _DownloadState.downloading:
        return SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            value: _progress > 0 ? _progress : null,
            strokeWidth: 2.5,
            color: color,
          ),
        );

      case _DownloadState.done:
        return Icon(Icons.check_circle_rounded, size: 22, color: color);

      case _DownloadState.error:
        return Icon(Icons.error_rounded, size: 22, color: Colors.red.shade300);

      case _DownloadState.idle:
        return const Icon(Icons.download_rounded, size: 18, color: color);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Color _colorForExt(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return const Color(0xffDC2626);
      case 'doc':
      case 'docx':
        return const Color(0xff2563EB);
      case 'xls':
      case 'xlsx':
        return const Color(0xff16A34A);
      case 'ppt':
      case 'pptx':
        return const Color(0xffEA580C);
      case 'zip':
      case 'rar':
        return const Color(0xff7C3AED);
      case 'txt':
        return const Color(0xff64748B);
      default:
        return AppColors.primary;
    }
  }

  IconData _iconForExt(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_rounded;
      case 'zip':
      case 'rar':
        return Icons.folder_zip_rounded;
      case 'txt':
        return Icons.text_snippet_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

}
