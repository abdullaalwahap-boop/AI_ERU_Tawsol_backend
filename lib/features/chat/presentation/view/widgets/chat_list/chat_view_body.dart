import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/private_chat_view.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/chat_body.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/chat_new_fab.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/conversation_actions_sheet.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/header/chat_header.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet.dart';

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => context
          .read<ChatCubit>()
          .searchConversations(_searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openChat(ChatConversation conversation) async {
    final cubit = context.read<ChatCubit>();
    cubit.openChat(conversation.otherUser.id);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrivateChatView(
          conversation: conversation,
          onLastMessageChanged: (msg) =>
              cubit.syncLastMessage(conversation.otherUser.id, msg),
        ),
      ),
    );
    if (mounted) cubit.closeChat();
  }

  Future<void> _openChatWithUser(ChatUser user) async {
    final cubit = context.read<ChatCubit>();
    cubit.openChat(user.id);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrivateChatView(
          conversation: ChatConversation(id: user.id, otherUser: user),
          onLastMessageChanged: (msg) =>
              cubit.syncLastMessage(user.id, msg),
        ),
      ),
    );
    if (mounted) cubit.closeChat();
  }

  void _openNewChat() {
    final cubit = context.read<ChatCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => BlocProvider.value(
        value: cubit,
        child: NewChatSheet(onSelectUser: _openChatWithUser),
      ),
    );
  }

  void _showConversationActions(ChatConversation conversation) {
    final cubit = context.read<ChatCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ConversationActionsSheet(
        conversation: conversation,
        onPin: () => cubit.pinConversation(conversation),
        onUnpin: () => cubit.unpinConversation(conversation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatInitial || state is ChatLoading) {
            return Scaffold(
              backgroundColor: context.colorBackground,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ChatError) {
            return Scaffold(
              backgroundColor: context.colorBackground,
              body: Center(child: Text(state.message)),
            );
          }

          final loaded = state as ChatLoaded;

          return Scaffold(
            backgroundColor: context.colorBackground,
            floatingActionButton: ChatNewFab(onTap: _openNewChat),
            body: Column(
              children: [
                ChatHeader(
                  isSearching: loaded.isSearching,
                  controller: _searchController,
                  onToggleSearch: () {
                    context.read<ChatCubit>().toggleSearch();
                    if (loaded.isSearching) _searchController.clear();
                  },
                  totalConversations: loaded.conversations.length,
                ),
                Expanded(
                  child: ChatBody(
                    loaded: loaded,
                    onOpenChat: _openChat,
                    onLongPress: _showConversationActions,
                    onRefresh: () => context.read<ChatCubit>().refresh(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
