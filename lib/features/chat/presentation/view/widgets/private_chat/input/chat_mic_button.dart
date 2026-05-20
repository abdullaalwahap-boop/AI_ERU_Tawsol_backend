import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

class ChatMicButton extends StatelessWidget {
  final VoidCallback onHold;

  const ChatMicButton({super.key, required this.onHold});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onHold,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.mic_rounded,
            color: AppColors.primary, size: 22),
      ),
    );
  }
}
