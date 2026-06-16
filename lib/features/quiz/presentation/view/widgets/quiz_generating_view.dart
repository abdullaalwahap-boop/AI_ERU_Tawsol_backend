import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class QuizGeneratingView extends StatelessWidget {
  const QuizGeneratingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            AppSpacing.h24,
            Text(
              AppLocalizations.of(context).generatingQuiz,
              style: AppTextStyles.titleMedium
                  .copyWith(color: context.colorTextPrimary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              AppLocalizations.of(context).generatingQuizDesc,
              style: AppTextStyles.bodySmall
                  .copyWith(color: context.colorTextSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
