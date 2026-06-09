import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_user_search_item.dart';

/// Bottom sheet opened by the FAB — search and start NEW conversations only.
///
/// Must be shown with [BlocProvider.value] so it shares the parent [ChatCubit]:
/// ```dart
/// showModalBottomSheet(
///   builder: (ctx) => BlocProvider.value(value: cubit, child: NewChatSheet(...)),
/// );
/// ```
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SheetHandle(),
                _SheetHeader(onClose: () => Navigator.pop(context)),
                _SheetSearchField(controller: _controller),
                Divider(height: 1, color: context.colorDivider),
                Flexible(
                  child: _buildBody(query, isLoading, users),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(String query, bool isLoading, List<ChatUser> users) {
    if (query.isEmpty) return const _SheetPrompt();
    if (isLoading) return const _SheetLoading();
    if (users.isEmpty) return _SheetNoResults(query: query);
    return _SheetUserList(users: users, onSelect: _select);
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: context.colorDivider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _SheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 12),
      child: Row(
        children: [
          Text(
            'New Chat',
            style: AppTextStyles.heading3
                .copyWith(color: context.colorTextPrimary),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, size: 22),
            color: context.colorTextSecondary,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _SheetSearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SheetSearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.bodyMedium
            .copyWith(color: context.colorTextPrimary),
        decoration: InputDecoration(
          hintText: 'Search by name or student ID…',
          hintStyle: AppTextStyles.bodyMedium
              .copyWith(color: context.colorTextHint),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colorTextHint,
            size: 20,
          ),
          filled: true,
          fillColor: context.colorInputBg,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _SheetPrompt extends StatelessWidget {
  const _SheetPrompt();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_search_rounded,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.h16,
          Text(
            'Find Someone to Chat With',
            style: AppTextStyles.titleMedium
                .copyWith(color: context.colorTextPrimary),
            textAlign: TextAlign.center,
          ),
          AppSpacing.h8,
          Text(
            'Search by name or student ID',
            style: AppTextStyles.bodySmall
                .copyWith(color: context.colorTextHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SheetLoading extends StatelessWidget {
  const _SheetLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _SheetNoResults extends StatelessWidget {
  final String query;

  const _SheetNoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: context.colorTextHint,
          ),
          AppSpacing.h16,
          Text(
            'No users found for "$query"',
            style: AppTextStyles.titleSmall
                .copyWith(color: context.colorTextSecondary),
            textAlign: TextAlign.center,
          ),
          AppSpacing.h8,
          Text(
            'Try a different name or student ID',
            style: AppTextStyles.bodySmall
                .copyWith(color: context.colorTextHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SheetUserList extends StatelessWidget {
  final List<ChatUser> users;
  final void Function(ChatUser) onSelect;

  const _SheetUserList({required this.users, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: users.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 76,
        endIndent: 16,
        color: context.colorDivider,
      ),
      itemBuilder: (_, i) => ChatUserSearchItem(
        user: users[i],
        onTap: () => onSelect(users[i]),
      ),
    );
  }
}
