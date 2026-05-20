import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class ChatNewFab extends StatelessWidget {
  final VoidCallback onTap;

  const ChatNewFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.edit_rounded, size: 20),
      label: Text(
        'New Chat',
        style: AppTextStyles.titleSmall,
      ),
    );
  }
}
