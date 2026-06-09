import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class ChatNoResultsState extends StatelessWidget {
  final String query;

  const ChatNoResultsState({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 56, color: context.colorTextHint),
          AppSpacing.h16,
          Text(
            AppLocalizations.of(context).noResultsFor(query),
            style: AppTextStyles.titleLarge.copyWith(color: context.colorTextSecondary),
          ),
          AppSpacing.h8,
          Text(
            AppLocalizations.of(context).tryDifferentName,
            style: AppTextStyles.bodySmall.copyWith(color: context.colorTextHint),
          ),
        ],
      ),
    );
  }
}
