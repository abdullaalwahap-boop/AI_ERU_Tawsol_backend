import 'dart:io';

import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_image_placeholder.dart';

class MessageImageContent extends StatelessWidget {
  final ChatMessage message;

  const MessageImageContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final url = message.fileUrl;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
        bottomLeft: Radius.circular(message.isFromMe ? 20 : 4),
        bottomRight: Radius.circular(message.isFromMe ? 4 : 20),
      ),
      child: SizedBox(
        width: 220,
        height: 160,
        child: url != null ? _buildImage(url) : const MessageImagePlaceholder(),
      ),
    );
  }

  Widget _buildImage(String url) {
    // Local file path — optimistic display before upload completes.
    if (!url.startsWith('http')) {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const MessageImagePlaceholder(),
      );
    }
    // Relative server path like /uploads/files/...
    final fullUrl =
        url.startsWith('/') ? '${ApiConstants.baseUrl}$url' : url;
    return Image.network(
      fullUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const MessageImagePlaceholder(),
    );
  }
}
