import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_emoji_picker.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_input_text_field.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_mic_button.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_send_button.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/sheets/attachment_bottom_sheet.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/voice/voice_recording_overlay.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/shared/chat_icon_button.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String text) onSendText;
  final VoidCallback? onSendVoice;
  final void Function(AttachmentOption) onAttachment;

  const ChatInputBar({
    super.key,
    required this.onSendText,
    this.onSendVoice,
    required this.onAttachment,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;
  bool _isRecording = false;
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _handleFocusChange() {
    // Close emoji picker when the user taps directly into the text field
    if (_focusNode.hasFocus && _showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSendText(text);
    _controller.clear();
  }

  void _startRecording() => setState(() {
        _isRecording = true;
        _showEmojiPicker = false;
      });

  void _cancelRecording() => setState(() => _isRecording = false);

  void _sendVoice() {
    setState(() => _isRecording = false);
    widget.onSendVoice?.call();
  }

  void _toggleEmojiPicker() {
    if (_showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
      _focusNode.requestFocus();
    } else {
      FocusScope.of(context).unfocus();
      setState(() => _showEmojiPicker = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isRecording) {
      return VoiceRecordingOverlay(
        onCancel: _cancelRecording,
        onSend: _sendVoice,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputRow(),
        if (_showEmojiPicker) ChatEmojiPicker(controller: _controller),
      ],
    );
  }

  Widget _buildInputRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChatIconButton(
              icon: Icons.attach_file_rounded,
              color: AppColors.textSecondary,
              onTap: () => AttachmentBottomSheet.show(
                context,
                onSelected: widget.onAttachment,
              ),
            ),
            AppSpacing.w8,
            Expanded(
              child: ChatInputTextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmit: _send,
                onEmojiTap: _toggleEmojiPicker,
                emojiActive: _showEmojiPicker,
              ),
            ),
            AppSpacing.w8,
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: _hasText
                  ? ChatSendButton(key: const ValueKey('send'), onTap: _send)
                  : ChatMicButton(
                      key: const ValueKey('mic'),
                      onHold: _startRecording,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
