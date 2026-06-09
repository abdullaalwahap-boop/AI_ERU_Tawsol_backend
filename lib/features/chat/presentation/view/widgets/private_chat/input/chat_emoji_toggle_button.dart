import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/shared/chat_icon_button.dart';

class ChatEmojiToggleButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const ChatEmojiToggleButton({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 4),
      child: ChatIconButton(
        icon: isActive
            ? Icons.emoji_emotions_rounded
            : Icons.emoji_emotions_outlined,
        color: isActive ? ChatColors.primary : context.colorTextHint,
        size: 20,
        onTap: onTap,
      ),
    );
  }
}
