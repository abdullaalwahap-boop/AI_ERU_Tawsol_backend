import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

/// Slim bar shown above the input field when the user has chosen to reply
/// to a message. Displays the original sender name and a content preview.
class ReplyPreviewBar extends StatelessWidget {
  final ChatMessage replyingTo;
  final String senderName;
  final VoidCallback onDismiss;

  const ReplyPreviewBar({
    super.key,
    required this.replyingTo,
    required this.senderName,
    required this.onDismiss,
  });

  String get _preview {
    if (replyingTo.isDeleted) return 'This message was deleted';
    return switch (replyingTo.type) {
      MessageType.voice => '🎤 Voice message',
      MessageType.image => '📷 Photo',
      MessageType.file => '📎 ${replyingTo.fileName ?? 'File'}',
      MessageType.text => replyingTo.text ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        border: Border(
          top: BorderSide(color: context.colorDivider, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  senderName,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _preview,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colorTextSecondary,
                    fontStyle: replyingTo.isDeleted
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded, size: 20),
            color: context.colorTextSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
