import 'dart:io';

import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/pages/image_viewer_page.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_image_placeholder.dart';
import 'package:flutter/material.dart';

class MessageImageContent extends StatelessWidget {
  final ChatMessage message;

  const MessageImageContent({super.key, required this.message});

  // Returns the URL ready to pass to Image.network, or null if local.
  String? get _remoteUrl {
    final url = message.fileUrl;
    if (url == null) return null;
    if (url.startsWith('/')) return '${ApiConstants.baseUrl}$url';
    if (url.startsWith('http')) return url;
    return null; // local file
  }

  bool get _isLocal {
    final url = message.fileUrl;
    if (url == null) return false;
    return !url.startsWith('/') && !url.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    final url = message.fileUrl;
    if (url == null) return const MessageImagePlaceholder();

    final heroTag = 'img_${message.id}';

    return GestureDetector(
      onTap: () => ImageViewerPage.open(
        context,
        imageUrl: url,
        heroTag: heroTag,
      ),
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isFromMe ? 20 : 4),
            bottomRight: Radius.circular(message.isFromMe ? 4 : 20),
          ),
          child: SizedBox(
            width: 220,
            height: 160,
            child: _buildThumbnail(),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (_isLocal) {
      return Image.file(
        File(message.fileUrl!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const MessageImagePlaceholder(),
      );
    }
    final remote = _remoteUrl;
    if (remote == null) return const MessageImagePlaceholder();
    return Image.network(
      remote,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xff1A3A7A),
          child: Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : null,
              color: Colors.white54,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => const MessageImagePlaceholder(),
    );
  }
}
