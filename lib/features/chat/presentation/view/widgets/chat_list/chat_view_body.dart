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
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_user_search_item.dart';
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
      () => context.read<ChatCubit>().search(_searchController.text),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'New chat — coming soon!',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        backgroundColor: AppColors.primary,
      ),
    );
  }

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
            return const Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ChatError) {
            return Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: Center(child: Text(state.message)),
            );
          }

          final loaded = state as ChatLoaded;

          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
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
                    onOpenUser: _openChatWithUser,
                    onNewChat: _openNewChat,
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

// ─── Chat body (conversations + user search results) ─────────────────────────

class _ChatBody extends StatelessWidget {
  final ChatLoaded loaded;
  final void Function(ChatConversation) onOpenChat;
  final void Function(ChatConversation) onLongPress;
  final void Function(ChatUser) onOpenUser;
  final VoidCallback onNewChat;
  final Future<void> Function() onRefresh;

  const _ChatBody({
    required this.loaded,
    required this.onOpenChat,
    required this.onLongPress,
    required this.onOpenUser,
    required this.onNewChat,
    required this.onRefresh,
  });

  bool get _isQuerying => loaded.isSearching && loaded.query.isNotEmpty;

  List<ChatUser> get _newUsers {
    final existingIds =
        loaded.conversations.map((c) => c.otherUser.id).toSet();
    return loaded.userSearchResults
        .where((u) => !existingIds.contains(u.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isQuerying) {
      if (loaded.conversations.isEmpty) {
        return EmptyChatsState(onNewChat: onNewChat);
      }
      return RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primary,
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: loaded.conversations.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: 76,
            endIndent: 16,
            color: AppColors.dividerLight,
          ),
          itemBuilder: (_, index) {
            final convo = loaded.conversations[index];
            return ChatListItem(
              conversation: convo,
              onTap: () => onOpenChat(convo),
              onLongPress: () => onLongPress(convo),
            );
          },
        ),
      );
    }

    final filteredConvos = loaded.filtered;
    final newUsers = _newUsers;
    final hasConvos = filteredConvos.isNotEmpty;
    final hasUsers = newUsers.isNotEmpty;
    final isLoading = loaded.isLoadingUserSearch;

    if (!hasConvos && !hasUsers && !isLoading) {
      return ChatNoResultsState(query: loaded.query);
    }

    return CustomScrollView(
      slivers: [
        if (hasConvos) ...[
          const _SectionHeader(title: 'Conversations'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final convo = filteredConvos[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChatListItem(
                      conversation: convo,
                      onTap: () => onOpenChat(convo),
                      onLongPress: () => onLongPress(convo),
                    ),
                    if (index < filteredConvos.length - 1)
                      const Divider(
                        height: 1,
                        indent: 76,
                        endIndent: 16,
                        color: AppColors.dividerLight,
                      ),
                  ],
                );
              },
              childCount: filteredConvos.length,
            ),
          ),
        ],
        if (isLoading || hasUsers) ...[
          const _SectionHeader(title: 'People'),
          if (isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  final user = newUsers[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ChatUserSearchItem(
                        user: user,
                        onTap: () => onOpenUser(user),
                      ),
                      if (index < newUsers.length - 1)
                        const Divider(
                          height: 1,
                          indent: 76,
                          endIndent: 16,
                          color: AppColors.dividerLight,
                        ),
                    ],
                  );
                },
                childCount: newUsers.length,
              ),
            ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
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
        color: AppColors.surfaceLight,
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
              color: AppColors.dividerLight,
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
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.dividerLight),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              isPinned ? onUnpin() : onPin();
            },
            borderRadius: AppRadius.medium,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
