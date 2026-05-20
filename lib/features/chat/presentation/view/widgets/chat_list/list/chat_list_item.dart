import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_list_item_avatar.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_list_item_subtitle.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_list_item_title.dart';

class ChatListItem extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.05),
      highlightColor: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ChatListItemAvatar(user: conversation.otherUser),
            AppSpacing.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatListItemTitle(conversation: conversation),
                  AppSpacing.h4,
                  ChatListItemSubtitle(conversation: conversation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
