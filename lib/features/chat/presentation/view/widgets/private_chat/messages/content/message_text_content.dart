import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/utils/link_utils.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/link_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart' show Linkify, LinkifyOptions;
import 'package:url_launcher/url_launcher.dart';

class MessageTextContent extends StatelessWidget {
  final ChatMessage message;

  const MessageTextContent({super.key, required this.message});

  // ── Deleted state ──────────────────────────────────────────────────────────

  Widget _buildDeleted(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.block_rounded,
            size: 13,
            color: message.isFromMe
                ? AppColors.sentBubbleText.withValues(alpha: 0.55)
                : context.colorTextHint,
          ),
          const SizedBox(width: 6),
          Text(
            'Message deleted',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: message.isFromMe
                  ? AppColors.sentBubbleText.withValues(alpha: 0.55)
                  : context.colorTextHint,
            ),
          ),
        ],
      ),
    );
  }

  // ── Normal text ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) return _buildDeleted(context);

    final text = message.text ?? '';
    final hasLink = LinkUtils.containsUrl(text);
    final previewUrl = hasLink ? LinkUtils.firstUrl(text) : null;

    final textColor = message.isFromMe
        ? AppColors.sentBubbleText
        : context.colorTextPrimary;

    final linkColor =
        message.isFromMe ? Colors.lightBlueAccent : AppColors.primary;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        14,
        10,
        14,
        previewUrl != null ? 8 : 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Text with tappable links ───────────────────────────────────────
          Linkify(
            text: text,
            onOpen: (link) async {
              try {
                final uri = Uri.tryParse(link.url);
                if (uri == null) return;
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (_) {}
            },
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14.5,
              height: 1.45,
              color: textColor,
            ),
            linkStyle: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14.5,
              height: 1.45,
              color: linkColor,
              decoration: TextDecoration.underline,
              decorationColor: linkColor,
            ),
            options: const LinkifyOptions(humanize: false),
          ),

          // ── Edited label ───────────────────────────────────────────────────
          if (message.editedAt != null) ...[
            const SizedBox(height: 3),
            Text(
              'edited',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: message.isFromMe
                    ? AppColors.sentBubbleText.withValues(alpha: 0.6)
                    : context.colorTextHint,
              ),
            ),
          ],

          // ── Link preview card ──────────────────────────────────────────────
          if (previewUrl != null) ...[
            const SizedBox(height: 8),
            LinkPreviewCard(
              url: previewUrl,
              isFromMe: message.isFromMe,
            ),
          ],
        ],
      ),
    );
  }
}
