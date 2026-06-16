import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/list/chat_user_search_item.dart';

class NewChatSheetUserList extends StatelessWidget {
  final List<ChatUser> users;
  final void Function(ChatUser) onSelect;

  const NewChatSheetUserList({
    super.key,
    required this.users,
    required this.onSelect,
  });

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
