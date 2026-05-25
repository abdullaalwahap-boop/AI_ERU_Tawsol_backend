import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/chat_search_bar.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_input_bar.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/messages/chat_message_list.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/scroll_to_bottom_button.dart';

class PrivateChatBody extends StatefulWidget {
  final ChatConversation conversation;

  const PrivateChatBody({super.key, required this.conversation});

  @override
  State<PrivateChatBody> createState() => _PrivateChatBodyState();
}

class _PrivateChatBodyState extends State<PrivateChatBody> {
  final _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // In a reverse:true list, pixel offset 0 IS the bottom.
  // The user is "away from bottom" when pixels > threshold.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final shouldShow = _scrollController.position.pixels > 120;
    if (shouldShow != _showScrollToBottom) {
      setState(() => _showScrollToBottom = shouldShow);
    }
  }

  // Instant jump — no animation, like WhatsApp.
  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _onAttachment(AttachmentOption option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${option.label} selected'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateChatCubit, PrivateChatState>(
      // Only auto-scroll when a new message is added — not on typing or search.
      // Initial load needs no scroll because reverse:true starts at the bottom.
      listenWhen: (prev, curr) {
        if (curr is! PrivateChatLoaded || curr.isSearching) return false;
        if (prev is! PrivateChatLoaded) return false;
        return curr.messages.length > prev.messages.length;
      },
      listener: (context, state) {
        final isNearBottom = !_scrollController.hasClients ||
            _scrollController.position.pixels < 120;
        if (isNearBottom) _jumpToBottom();
      },
      builder: (context, state) {
        if (state is PrivateChatInitial || state is PrivateChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PrivateChatError) {
          return Center(child: Text(state.message));
        }

        final loaded = state as PrivateChatLoaded;

        return Column(
          children: [
            if (loaded.isSearching)
              ChatSearchBar(
                onChanged: (q) =>
                    context.read<PrivateChatCubit>().searchMessages(q),
                onClose: () => context.read<PrivateChatCubit>().toggleSearch(),
              ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: AppColors.backgroundLight,
                    child: ChatMessageList(
                      scrollController: _scrollController,
                      messages: loaded.displayMessages,
                      isSearching: loaded.isSearching,
                      isOtherTyping: loaded.isOtherTyping,
                      searchQuery: loaded.searchQuery,
                      otherUser: widget.conversation.otherUser,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: ScrollToBottomButton(
                      visible: _showScrollToBottom,
                      onTap: () {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(0);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (!loaded.isSearching)
              ChatInputBar(
                onSendText: (text) =>
                    context.read<PrivateChatCubit>().sendTextMessage(text),
                onSendVoice: () =>
                    context.read<PrivateChatCubit>().sendVoiceMessage(),
                onAttachment: _onAttachment,
              ),
          ],
        );
      },
    );
  }
}
