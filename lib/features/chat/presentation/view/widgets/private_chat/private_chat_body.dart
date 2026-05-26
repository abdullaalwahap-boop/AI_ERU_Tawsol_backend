import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/attachment_service.dart';
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
  final _highlightedId = ValueNotifier<String?>(null);
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _highlightedId.dispose();
    super.dispose();
  }

  // In a reverse:true list, pixel offset 0 IS the bottom.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final shouldShow = _scrollController.position.pixels > 120;
    if (shouldShow != _showScrollToBottom) {
      setState(() => _showScrollToBottom = shouldShow);
    }
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  /// Scroll the list so [messageId] becomes visible, then briefly highlight it.
  /// Handles both visible items (direct ensureVisible) and off-screen items
  /// (fraction-based jump first, then ensureVisible).
  Future<void> _scrollToMessage(String messageId) async {
    // Capture cubit reference before any await to avoid context-across-async-gap.
    final cubit = context.read<PrivateChatCubit>();

    // Fast path: item already in viewport.
    var ctx = GlobalObjectKey(messageId).currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
      _triggerHighlight(messageId);
      return;
    }

    // Item is outside the built range — jump to an approximate position so
    // ListView.builder constructs it, then fine-tune with ensureVisible.
    if (!_scrollController.hasClients) return;
    final cubitState = cubit.state;
    if (cubitState is! PrivateChatLoaded) return;

    final reversed = cubitState.displayMessages.reversed.toList();
    final idx = reversed.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent > 0) {
      final fraction = idx / reversed.length.toDouble();
      _scrollController.jumpTo((maxExtent * fraction).clamp(0.0, maxExtent));
    }

    // Give the builder one frame to construct the now-visible item.
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;

    ctx = GlobalObjectKey(messageId).currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
    _triggerHighlight(messageId);
  }

  void _triggerHighlight(String messageId) {
    _highlightedId.value = messageId;
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted && _highlightedId.value == messageId) {
        _highlightedId.value = null;
      }
    });
  }

  Future<void> _onAttachment(AttachmentOption option) async {
    final cubit = context.read<PrivateChatCubit>();
    final svc = AttachmentService.instance;

    PickedFile? picked;
    switch (option) {
      case AttachmentOption.camera:
        picked = await svc.pickFromCamera();
      case AttachmentOption.gallery:
        picked = await svc.pickFromGallery();
      case AttachmentOption.document:
        picked = await svc.pickDocument();
      default:
        return;
    }

    if (picked == null || !mounted) return;
    cubit.sendAttachment(
      filePath: picked.path,
      fileName: picked.name,
      pickedType: picked.type,
    );
  }

  String _senderName(ChatMessage message) =>
      message.isFromMe ? 'You' : widget.conversation.otherUser.name;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrivateChatCubit, PrivateChatState>(
      listenWhen: (prev, curr) {
        if (curr is! PrivateChatLoaded || curr.isSearching) return false;
        if (prev is! PrivateChatLoaded) return false;
        if (curr.sendError != null && curr.sendError != prev.sendError) {
          return true;
        }
        return curr.messages.length > prev.messages.length;
      },
      listener: (context, state) {
        if (state is! PrivateChatLoaded) return;
        if (state.sendError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.sendError!),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        // Always jump to bottom when the current user sends a message,
        // regardless of scroll position. For incoming messages, only jump
        // when already near the bottom (< 120 px from it).
        final lastMsg = state.messages.isNotEmpty ? state.messages.last : null;
        if (lastMsg?.isFromMe == true) {
          _jumpToBottom();
          return;
        }
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
                      highlightedId: _highlightedId,
                      onScrollToMessage: _scrollToMessage,
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
                onSendVoice: (filePath, durationSeconds) =>
                    context.read<PrivateChatCubit>().sendVoiceMessage(
                          filePath: filePath,
                          durationSeconds: durationSeconds,
                        ),
                onAttachment: _onAttachment,
                replyingTo: loaded.replyingTo,
                replyingToSenderName: loaded.replyingTo != null
                    ? _senderName(loaded.replyingTo!)
                    : null,
                onCancelReply: () =>
                    context.read<PrivateChatCubit>().setReplyTo(null),
              ),
          ],
        );
      },
    );
  }
}
