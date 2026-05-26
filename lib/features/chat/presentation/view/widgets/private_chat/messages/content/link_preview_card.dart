import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Compact link-preview card shown inside a chat bubble.
/// Mirrors the WhatsApp/Telegram pattern: fetches OG metadata and displays
/// site name, title, description and lead image.
class LinkPreviewCard extends StatelessWidget {
  final String url;
  final bool isFromMe;

  const LinkPreviewCard({
    super.key,
    required this.url,
    required this.isFromMe,
  });

  Future<void> _open() async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isFromMe
        ? const Color(0xff1A3566) // slightly darker than sent bubble
        : const Color(0xffEEF0F4);
    final borderColor = isFromMe
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);
    final titleColor = isFromMe ? Colors.white : const Color(0xff1A1A1A);
    final bodyColor =
        isFromMe ? Colors.white70 : const Color(0xff555555);

    return GestureDetector(
      onTap: _open,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: AnyLinkPreview(
            link: url,
            displayDirection: UIDirection.uiDirectionVertical,
            showMultimedia: true,
            bodyMaxLines: 2,
            bodyTextOverflow: TextOverflow.ellipsis,
            titleStyle: TextStyle(
              color: titleColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            bodyStyle: TextStyle(
              color: bodyColor,
              fontSize: 12,
              height: 1.4,
            ),
            errorWidget: const SizedBox.shrink(),
            cache: const Duration(hours: 24),
            backgroundColor: Colors.transparent,
            borderRadius: 0,
            removeElevation: true,
            boxShadow: const [],
          ),
        ),
      ),
    );
  }
}
