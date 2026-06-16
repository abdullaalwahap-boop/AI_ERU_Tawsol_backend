import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet_handle.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet_header.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet_loading.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet_no_results.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet_prompt.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet_search_field.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/new_chat_sheet_user_list.dart';

class NewChatSheet extends StatefulWidget {
  final void Function(ChatUser user) onSelectUser;

  const NewChatSheet({super.key, required this.onSelectUser});

  @override
  State<NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends State<NewChatSheet> {
  final _controller = TextEditingController();
  late final ChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChatCubit>();
    _controller.addListener(
      () => _cubit.searchNewUsers(_controller.text.trim()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.clearNewUserSearch();
    super.dispose();
  }

  void _select(ChatUser user) {
    Navigator.pop(context);
    widget.onSelectUser(user);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (prev, curr) {
        if (curr is! ChatLoaded) return false;
        if (prev is! ChatLoaded) return true;
        return curr.userSearchResults != prev.userSearchResults ||
            curr.isLoadingUserSearch != prev.isLoadingUserSearch;
      },
      builder: (context, state) {
        final loaded = state is ChatLoaded ? state : null;
        final existingIds =
            loaded?.conversations.map((c) => c.otherUser.id).toSet() ??
                const <String>{};
        final users = loaded?.userSearchResults
                .where((u) => !existingIds.contains(u.id))
                .toList() ??
            const [];
        final isLoading = loaded?.isLoadingUserSearch ?? false;
        final query = _controller.text.trim();

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.88,
            ),
            decoration: BoxDecoration(
              color: context.colorSurface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NewChatSheetHandle(),
                NewChatSheetHeader(
                    onClose: () => Navigator.pop(context)),
                NewChatSheetSearchField(controller: _controller),
                Divider(height: 1, color: context.colorDivider),
                Flexible(child: _buildBody(query, isLoading, users)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(String query, bool isLoading, List<ChatUser> users) {
    if (query.isEmpty) return const NewChatSheetPrompt();
    if (isLoading) return const NewChatSheetLoading();
    if (users.isEmpty) return NewChatSheetNoResults(query: query);
    return NewChatSheetUserList(users: users, onSelect: _select);
  }
}
