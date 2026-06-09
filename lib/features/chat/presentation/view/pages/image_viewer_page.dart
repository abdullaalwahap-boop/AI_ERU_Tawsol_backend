import 'dart:io';
import 'dart:typed_data';

import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

class ImageViewerPage extends StatefulWidget {
  /// Local file path OR server-relative path (/uploads/...) OR full http URL.
  final String imageUrl;
  final String? heroTag;

  const ImageViewerPage({
    super.key,
    required this.imageUrl,
    this.heroTag,
  });

  static Future<void> open(
    BuildContext context, {
    required String imageUrl,
    String? heroTag,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => ImageViewerPage(
          imageUrl: imageUrl,
          heroTag: heroTag,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  bool _saving = false;

  bool get _isLocal =>
      !widget.imageUrl.startsWith('/') && !widget.imageUrl.startsWith('http');

  String get _resolvedUrl {
    if (widget.imageUrl.startsWith('/')) {
      return '${ApiConstants.baseUrl}${widget.imageUrl}';
    }
    return widget.imageUrl;
  }

  Future<void> _saveToGallery() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      if (_isLocal) {
        await Gal.putImage(widget.imageUrl);
      } else {
        final response = await Dio().get<Uint8List>(
          _resolvedUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = response.data;
        if (bytes == null) throw Exception('Empty response');
        await Gal.putImageBytes(bytes);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).imageSavedToGallery),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotSaveImage),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.download_rounded),
                  tooltip: AppLocalizations.of(context).saveToGallery,
                  onPressed: _saveToGallery,
                ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 6.0,
          child: _buildFullImage(),
        ),
      ),
    );
  }

  Widget _buildFullImage() {
    final tag = widget.heroTag;

    final imageWidget = _isLocal
        ? Image.file(
            File(widget.imageUrl),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _brokenIcon(),
          )
        : Image.network(
            _resolvedUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (_, __, ___) => _brokenIcon(),
          );

    if (tag != null) {
      return Hero(tag: tag, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _brokenIcon() => const Center(
        child: Icon(Icons.broken_image_rounded, color: Colors.white38, size: 72),
      );
}
