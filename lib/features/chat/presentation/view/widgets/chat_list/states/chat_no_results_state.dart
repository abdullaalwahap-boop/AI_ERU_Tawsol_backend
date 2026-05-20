import 'package:flutter/material.dart';
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
          const Icon(Icons.search_off_rounded,
              size: 56, color: AppColors.textHint),
          AppSpacing.h16,
          Text(
            'No results for "$query"',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.textSecondary),
          ),
          AppSpacing.h8,
          Text(
            'Try a different name or student ID',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
