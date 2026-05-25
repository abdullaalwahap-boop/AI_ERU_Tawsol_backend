import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class MessageTextContent extends StatelessWidget {
  final ChatMessage message;

  const MessageTextContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
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
                  : AppColors.textHint,
            ),
            const SizedBox(width: 6),
            Text(
              'Message deleted',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: message.isFromMe
                    ? AppColors.sentBubbleText.withValues(alpha: 0.55)
                    : AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14.5,
              height: 1.45,
              color: message.isFromMe
                  ? AppColors.sentBubbleText
                  : AppColors.receivedBubbleText,
            ),
          ),
          if (message.editedAt != null) ...[
            const SizedBox(height: 3),
            Text(
              'edited',
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: message.isFromMe
                    ? AppColors.sentBubbleText.withValues(alpha: 0.6)
                    : AppColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
