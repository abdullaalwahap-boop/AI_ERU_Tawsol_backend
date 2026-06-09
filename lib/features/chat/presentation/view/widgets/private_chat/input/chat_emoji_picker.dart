import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class ChatEmojiPicker extends StatelessWidget {
  final TextEditingController controller;
  final double height;

  const ChatEmojiPicker({
    super.key,
    required this.controller,
    this.height = 256,
  });

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      textEditingController: controller,
      config: Config(
        height: height,
        checkPlatformCompatibility: false,
        emojiViewConfig: EmojiViewConfig(
          backgroundColor: context.colorSurface,
          buttonMode: ButtonMode.MATERIAL,
        ),
        categoryViewConfig: CategoryViewConfig(
          backgroundColor: context.colorSurface,
          indicatorColor: ChatColors.primary,
          iconColor: context.colorTextHint,
          iconColorSelected: ChatColors.primary,
          backspaceColor: ChatColors.primary,
        ),
        bottomActionBarConfig: BottomActionBarConfig(
          backgroundColor: context.colorSurface,
          buttonColor: ChatColors.primary.withValues(alpha: 0.1),
          buttonIconColor: ChatColors.primary,
        ),
      ),
    );
  }
}
