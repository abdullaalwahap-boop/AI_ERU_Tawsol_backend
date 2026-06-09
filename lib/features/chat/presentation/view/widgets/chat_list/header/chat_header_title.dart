import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ChatHeaderTitle extends StatelessWidget {
  final int totalConversations;

  const ChatHeaderTitle({super.key, required this.totalConversations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).messages,
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        AppSpacing.h3,
        Text(
          AppLocalizations.of(context).conversations(totalConversations),
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
