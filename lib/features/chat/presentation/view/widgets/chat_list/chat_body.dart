import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_list_item.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/states/chat_no_results_state.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/states/empty_chats_state.dart';

class ChatBody extends StatelessWidget {
  final ChatLoaded loaded;
  final void Function(ChatConversation) onOpenChat;
  final void Function(ChatConversation) onLongPress;
  final Future<void> Function() onRefresh;

  const ChatBody({
    super.key,
    required this.loaded,
    required this.onOpenChat,
    required this.onLongPress,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final conversations =
        loaded.isSearching ? loaded.filtered : loaded.conversations;

    if (!loaded.isSearching && conversations.isEmpty) {
      return const EmptyChatsState();
    }

    if (loaded.isSearching &&
        loaded.query.isNotEmpty &&
        conversations.isEmpty) {
      return ChatNoResultsState(query: loaded.query);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: conversations.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 76,
          endIndent: 16,
          color: context.colorDivider,
        ),
        itemBuilder: (_, index) {
          final convo = conversations[index];
          return ChatListItem(
            conversation: convo,
            onTap: () => onOpenChat(convo),
            onLongPress: () => onLongPress(convo),
          );
        },
      ),
    );
  }
}
