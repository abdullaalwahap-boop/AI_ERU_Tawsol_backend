import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/voice_recorder_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_emoji_picker.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_input_text_field.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_mic_button.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_send_button.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/reply_preview_bar.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/sheets/attachment_bottom_sheet.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/voice/voice_recording_overlay.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/shared/chat_icon_button.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String text) onSendText;
  final void Function(String filePath, int durationSeconds)? onSendVoice;
  final void Function(AttachmentOption) onAttachment;

  /// Currently active reply target (null when not replying).
  final ChatMessage? replyingTo;

  /// Display name of the original sender — "You" or partner's name.
  final String? replyingToSenderName;

  /// Called when the user taps the X button on the reply bar.
  final VoidCallback? onCancelReply;

  const ChatInputBar({
    super.key,
    required this.onSendText,
    this.onSendVoice,
    required this.onAttachment,
    this.replyingTo,
    this.replyingToSenderName,
    this.onCancelReply,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final VoiceRecorderService _recorder;

  bool _hasText = false;
  bool _isRecording = false;
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _recorder = getIt<VoiceRecorderService>();
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

  Future<void> _startRecording() async {
    final messenger = ScaffoldMessenger.of(context);
    final granted = await _recorder.requestPermission();
    if (!granted) {
      if (!mounted) return;
      final permanentlyDenied = await _recorder.isPermanentlyDenied();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(permanentlyDenied
              ? AppLocalizations.of(context).micPermissionDenied
              : AppLocalizations.of(context).micPermissionRequired),
          action: permanentlyDenied
              ? SnackBarAction(
                  label: AppLocalizations.of(context).settings,
                  onPressed: openAppSettings,
                )
              : null,
        ),
      );
      return;
    }

    final started = await _recorder.startRecording();
    if (!started || !mounted) return;

    setState(() {
      _isRecording = true;
      _showEmojiPicker = false;
    });
  }

  Future<void> _cancelRecording() async {
    await _recorder.cancelRecording();
    if (mounted) setState(() => _isRecording = false);
  }

  Future<void> _sendVoice() async {
    final result = await _recorder.stopRecording();
    if (!mounted) return;
    setState(() => _isRecording = false);
    if (result != null) {
      widget.onSendVoice?.call(result.filePath, result.durationSeconds);
    }
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
        amplitudeStream: _recorder.amplitudeStream,
        onCancel: _cancelRecording,
        onSend: _sendVoice,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyingTo != null)
          ReplyPreviewBar(
            replyingTo: widget.replyingTo!,
            senderName: widget.replyingToSenderName ?? '',
            onDismiss: widget.onCancelReply ?? () {},
          ),
        _buildInputRow(),
        if (_showEmojiPicker) ChatEmojiPicker(controller: _controller),
      ],
    );
  }

  Widget _buildInputRow() {
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
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
              color: context.colorTextSecondary,
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
                      onTap: _startRecording,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
