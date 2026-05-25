import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/shared/message_status_icon.dart';
import 'package:ai_eru_tawasol/features/chat/utils/chat_time_formatter.dart';

class MessageBubbleFooter extends StatelessWidget {
  final ChatMessage message;

  const MessageBubbleFooter({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromMe;
    final time = ChatTimeFormatter.formatMessageTime(message.timestamp);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint),
        ),
        if (isMe) ...[
          AppSpacing.w4,
          MessageStatusIcon(status: message.status),
        ],
      ],
    );
  }
}
