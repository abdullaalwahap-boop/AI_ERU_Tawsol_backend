import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_emoji_toggle_button.dart';

class ChatInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;
  final VoidCallback onEmojiTap;
  final bool emojiActive;

  const ChatInputTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
    required this.onEmojiTap,
    this.emojiActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 130),
      decoration: BoxDecoration(
        color: AppColors.inputBgLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: focusNode.hasFocus
              ? AppColors.primary.withValues(alpha: 0.4)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppSpacing.w16,
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14.5,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message…',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14.5,
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                isDense: true,
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          ChatEmojiToggleButton(
            isActive: emojiActive,
            onTap: onEmojiTap,
          ),
        ],
      ),
    );
  }
}
