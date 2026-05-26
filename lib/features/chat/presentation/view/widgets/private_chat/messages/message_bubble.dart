import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/message_bubble_footer.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/replied_message_widget.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_file_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_image_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_text_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_voice_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/sheets/message_actions_sheet.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  /// Resolved original message for the reply card (null if no reply or not found).
  final ChatMessage? replyToMessage;

  /// Other user's name — used for labelling reply cards.
  final String otherUserName;

  /// Called when the user taps the reply card inside this bubble.
  final void Function(String messageId)? onScrollToMessage;

  /// Shared notifier — when value == message.id, briefly highlight this bubble.
  final ValueNotifier<String?> highlightedId;

  const MessageBubble({
    super.key,
    required this.message,
    required this.otherUserName,
    required this.highlightedId,
    this.replyToMessage,
    this.onScrollToMessage,
  });

  // ── Actions ────────────────────────────────────────────────────────────────

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MessageActionsSheet(
        message: message,
        onReply: () =>
            context.read<PrivateChatCubit>().setReplyTo(message),
        onCopy: message.type == MessageType.text &&
                (message.text?.isNotEmpty ?? false)
            ? () => _copyText(context)
            : null,
        onEdit: (newText) =>
            context.read<PrivateChatCubit>().editMessage(message.id, newText),
        onDelete: () =>
            context.read<PrivateChatCubit>().deleteMessage(message.id),
      ),
    );
  }

  void _copyText(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.text!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message copied'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromMe;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;

    return ValueListenableBuilder<String?>(
      valueListenable: highlightedId,
      builder: (context, hId, _) {
        final isHighlighted = hId == message.id;

        return GestureDetector(
          onLongPress:
              !message.isDeleted ? () => _showActions(context) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            color: isHighlighted
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment:
                    isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.sentBubble
                              : AppColors.receivedBubble,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isMe ? 20 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isMe
                                  ? AppColors.primary.withValues(alpha: 0.18)
                                  : Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildContent(isMe),
                      ),
                      AppSpacing.h3,
                      MessageBubbleFooter(message: message),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(bool isMe) {
    final replyCard = replyToMessage != null
        ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: RepliedMessageWidget(
              original: replyToMessage!,
              senderName: replyToMessage!.isFromMe ? 'You' : otherUserName,
              isFromMe: isMe,
              onTap: onScrollToMessage != null
                  ? () => onScrollToMessage!(replyToMessage!.id)
                  : null,
            ),
          )
        : null;

    final content = switch (message.type) {
      MessageType.text => MessageTextContent(message: message),
      MessageType.image => MessageImageContent(message: message),
      MessageType.voice => MessageVoiceContent(message: message),
      MessageType.file => MessageFileContent(message: message),
    };

    if (replyCard == null) return content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [replyCard, content],
    );
  }
}
