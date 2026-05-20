import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

class ChatAppBarAvatar extends StatelessWidget {
  final ChatUser user;

  const ChatAppBarAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white.withValues(alpha: 0.25),
          child: Text(
            user.initials,
            style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
          ),
        ),
        if (user.isOnline)
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}
