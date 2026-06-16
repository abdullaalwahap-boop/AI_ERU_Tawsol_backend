import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_attempt.dart';

class ReviewTile extends StatelessWidget {
  final int number;
  final QuizAttempt attempt;

  const ReviewTile({super.key, required this.number, required this.attempt});

  @override
  Widget build(BuildContext context) {
    final result = attempt.result;
    final correct = result?.correct ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: correct ? AppColors.success : AppColors.error,
          width: 1.2,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: correct ? AppColors.success : AppColors.error,
                size: 18,
              ),
              AppSpacing.w8,
              Text(
                'Q$number',
                style: AppTextStyles.labelMedium.copyWith(
                  color: correct ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppSpacing.h6,
          Text(
            attempt.question.question,
            style: AppTextStyles.bodySmall
                .copyWith(color: context.colorTextPrimary, height: 1.4),
          ),
          if (result != null) ...[
            AppSpacing.h6,
            Text(
              'Your answer: ${attempt.selectedAnswer ?? '—'}  •  '
              'Correct: ${result.correctAnswer}',
              style: AppTextStyles.labelSmall.copyWith(
                color: correct ? AppColors.success : AppColors.error,
              ),
            ),
            AppSpacing.h4,
            Text(
              result.explanation,
              style: AppTextStyles.labelSmall
                  .copyWith(color: context.colorTextSecondary, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
