import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class NewChatSheetNoResults extends StatelessWidget {
  final String query;

  const NewChatSheetNoResults({super.key, required this.query});

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
            AppLocalizations.of(context).noUsersFoundFor(query),
            style: AppTextStyles.titleSmall
                .copyWith(color: context.colorTextSecondary),
            textAlign: TextAlign.center,
          ),
          AppSpacing.h8,
          Text(
            AppLocalizations.of(context).tryDifferentName,
            style: AppTextStyles.bodySmall
                .copyWith(color: context.colorTextHint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
