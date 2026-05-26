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

    // Already downloaded in this session — just open.
    if (_state == _DownloadState.done && _savedPath != null) {
      await OpenFilex.open(_savedPath!);
      return;
    }

    // Local optimistic file — open directly.
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
      // Reset to idle after showing error.
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _state = _DownloadState.idle);
    }
  }

  String _urlFileName(String url) =>
      url.split('/').last.split('?').first.isNotEmpty
          ? url.split('/').last.split('?').first
          : 'file';

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
                    ? Colors.white.withValues(alpha: 0.2)
                    : const Color(0xffEEF2FF),
                borderRadius: BorderRadius.circular(10),
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
                          : AppColors.receivedBubbleText,
                    ),
                  ),
                  if (sizeText.isNotEmpty) ...[
                    AppSpacing.h2,
                    Text(
                      sizeText,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isMe
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            AppSpacing.w8,

            // ── Action button ────────────────────────────────────────────────
            _buildActionIcon(isMe),
          ],
        ),
      ),
    );
  }
}
