import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

/// Compact quoted-message card rendered inside a bubble when the message
/// is a reply. The accent line and colours adapt to whether the outer
/// bubble is sent (isFromMe=true) or received.
class RepliedMessageWidget extends StatelessWidget {
  final ChatMessage original;
  final String senderName;
  final bool isFromMe;
  final VoidCallback? onTap;

  const RepliedMessageWidget({
    super.key,
    required this.original,
    required this.senderName,
    required this.isFromMe,
    this.onTap,
  });

  String get _preview {
    if (original.isDeleted) return 'This message was deleted';
    return switch (original.type) {
      MessageType.voice => '🎤 Voice message',
      MessageType.image => '📷 Photo',
      MessageType.file => '📎 ${original.fileName ?? 'File'}',
      MessageType.text => original.text ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final accentColor =
        isFromMe ? Colors.white.withValues(alpha: 0.55) : AppColors.primary;
    final bgColor = isFromMe
        ? Colors.white.withValues(alpha: 0.14)
        : AppColors.primary.withValues(alpha: 0.09);
    final nameColor =
        isFromMe ? Colors.white.withValues(alpha: 0.9) : AppColors.primary;
    final previewColor = isFromMe
        ? Colors.white.withValues(alpha: 0.72)
        : context.colorTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9, 6, 10, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        senderName,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: nameColor,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _preview,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: previewColor,
                          fontStyle: original.isDeleted
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
