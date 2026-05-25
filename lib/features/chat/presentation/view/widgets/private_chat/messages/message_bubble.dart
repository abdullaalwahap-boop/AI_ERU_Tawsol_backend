import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/message_bubble_footer.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_file_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_image_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_text_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/content/message_voice_content.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/sheets/message_actions_sheet.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  void _showActions(BuildContext context) {
    if (!message.canEdit && !message.canDelete) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MessageActionsSheet(
        message: message,
        onEdit: (newText) =>
            context.read<PrivateChatCubit>().editMessage(message.id, newText),
        onDelete: () =>
            context.read<PrivateChatCubit>().deleteMessage(message.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isFromMe;

    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;

    return GestureDetector(
      onLongPress:
          (isMe && !message.isDeleted) ? () => _showActions(context) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        isMe ? AppColors.sentBubble : AppColors.receivedBubble,
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
                  child: _buildContent(),
                ),
                AppSpacing.h3,
                MessageBubbleFooter(message: message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case MessageType.text:
        return MessageTextContent(message: message);
      case MessageType.image:
        return MessageImageContent(message: message);
      case MessageType.voice:
        return MessageVoiceContent(message: message);
      case MessageType.file:
        return MessageFileContent(message: message);
    }
  }
}
