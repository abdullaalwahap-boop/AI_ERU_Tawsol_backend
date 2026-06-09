import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;
  final double size;

  const MessageStatusIcon({
    super.key,
    required this.status,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.access_time_rounded,
            size: size, color: context.colorTextHint);
      case MessageStatus.sent:
        return Icon(Icons.check_rounded,
            size: size, color: context.colorTextHint);
      case MessageStatus.delivered:
        return Icon(Icons.done_all_rounded,
            size: size, color: context.colorTextHint);
      case MessageStatus.seen:
        return Icon(Icons.done_all_rounded,
            size: size, color: AppColors.primary);
    }
  }
}
