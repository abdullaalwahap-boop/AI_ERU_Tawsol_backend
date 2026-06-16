import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/chat_search_nav_button.dart';

class ChatSearchNavBlock extends StatelessWidget {
  final int currentPosition;
  final int resultCount;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const ChatSearchNavBlock({
    super.key,
    required this.currentPosition,
    required this.resultCount,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChatSearchNavButton(
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: onPrev,
        ),
        ChatSearchNavButton(
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: onNext,
        ),
        AppSpacing.w4,
        Text(
          '$currentPosition / $resultCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
