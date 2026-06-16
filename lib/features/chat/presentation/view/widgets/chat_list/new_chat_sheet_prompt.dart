import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class NewChatSheetPrompt extends StatelessWidget {
  const NewChatSheetPrompt({super.key});

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
            AppLocalizations.of(context).findSomeoneToChatWith,
            style: AppTextStyles.titleMedium
                .copyWith(color: context.colorTextPrimary),
            textAlign: TextAlign.center,
          ),
          AppSpacing.h8,
          Text(
            AppLocalizations.of(context).searchByNameOrId,
            style: AppTextStyles.bodySmall
                .copyWith(color: context.colorTextHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
