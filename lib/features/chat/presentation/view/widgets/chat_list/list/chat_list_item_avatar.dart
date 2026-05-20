import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class ChatListItemAvatar extends StatelessWidget {
  final ChatUser user;

  const ChatListItemAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: user.role.color.withValues(alpha: 0.15),
          child: Text(
            user.initials,
            style: AppTextStyles.titleLarge.copyWith(color: user.role.color),
          ),
        ),
        if (user.isOnline)
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
