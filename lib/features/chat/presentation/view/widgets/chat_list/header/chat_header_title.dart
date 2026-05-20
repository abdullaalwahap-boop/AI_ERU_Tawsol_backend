import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class ChatHeaderTitle extends StatelessWidget {
  final int totalConversations;

  const ChatHeaderTitle({super.key, required this.totalConversations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Messages',
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          '$totalConversations conversations',
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
