import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/header/chat_header_title.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/header/chat_search_bar.dart';

class ChatHeader extends StatelessWidget {
  final bool isSearching;
  final TextEditingController controller;
  final VoidCallback onToggleSearch;
  final int totalConversations;

  const ChatHeader({
    super.key,
    required this.isSearching,
    required this.controller,
    required this.onToggleSearch,
    required this.totalConversations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22003096),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
              child: Row(
                children: [
                  ChatHeaderTitle(totalConversations: totalConversations),
                  const Spacer(),
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isSearching
                            ? Icons.close_rounded
                            : Icons.search_rounded,
                        key: ValueKey(isSearching),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    onPressed: onToggleSearch,
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: isSearching
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: ChatSearchBar(controller: controller),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
