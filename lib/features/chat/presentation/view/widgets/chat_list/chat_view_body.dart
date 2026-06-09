import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/private_chat_view.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/chat_new_fab.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/header/chat_header.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_list_item.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/states/chat_no_results_state.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/states/empty_chats_state.dart';

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

  // ── Navigation ─────────────────────────────────────────────────────────────

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

  // ── FAB: open New Chat sheet ───────────────────────────────────────────────

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

  // ── Long-press actions ─────────────────────────────────────────────────────

  void _showConversationActions(ChatConversation conversation) {
    final cubit = context.read<ChatCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConversationActionsSheet(
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
                  child: _ChatBody(
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

// ─── Chat body — conversations only ──────────────────────────────────────────

class _ChatBody extends StatelessWidget {
  final ChatLoaded loaded;
  final void Function(ChatConversation) onOpenChat;
  final void Function(ChatConversation) onLongPress;
  final Future<void> Function() onRefresh;

  const _ChatBody({
    required this.loaded,
    required this.onOpenChat,
    required this.onLongPress,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // While searching but no query yet: show the full conversation list.
    final conversations =
        loaded.isSearching ? loaded.filtered : loaded.conversations;

    // Empty state — only when not in search mode.
    if (!loaded.isSearching && conversations.isEmpty) {
      return const EmptyChatsState();
    }

    // No results for current search query.
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

// ─── Conversation actions bottom sheet ────────────────────────────────────────

class _ConversationActionsSheet extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onPin;
  final VoidCallback onUnpin;

  const _ConversationActionsSheet({
    required this.conversation,
    required this.onPin,
    required this.onUnpin,
  });

  @override
  Widget build(BuildContext context) {
    final isPinned = conversation.isPinned;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: AppRadius.large,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: context.colorDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: conversation.otherUser.role.lightColor,
                  child: Text(
                    conversation.otherUser.initials,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: conversation.otherUser.role.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppSpacing.w12,
                Expanded(
                  child: Text(
                    conversation.otherUser.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: context.colorTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.colorDivider),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              isPinned ? onUnpin() : onPin();
            },
            borderRadius: AppRadius.medium,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isPinned
                          ? Icons.push_pin_outlined
                          : Icons.push_pin_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  AppSpacing.w12,
                  Text(
                    isPinned ? 'Unpin conversation' : 'Pin conversation',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
