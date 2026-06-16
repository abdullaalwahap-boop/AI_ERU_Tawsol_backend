import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class QuizErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const QuizErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 56),
            AppSpacing.h16,
            Text(
              AppLocalizations.of(context).couldNotGenerateQuiz,
              style: AppTextStyles.heading4
                  .copyWith(color: context.colorTextPrimary),
            ),
            AppSpacing.h8,
            Text(
              message,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: context.colorTextSecondary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text(AppLocalizations.of(context).goBack),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
                if (onRetry != null) ...[
                  AppSpacing.w12,
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(AppLocalizations.of(context).tryAgain),
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
