import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_answer_result.dart';

class ExplanationCard extends StatelessWidget {
  final QuizAnswerResult result;
  const ExplanationCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final correct = result.correct;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: correct ? AppColors.successLight : AppColors.errorLight,
        borderRadius: AppRadius.large,
        border: Border.all(
          color: correct ? AppColors.success : AppColors.error,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct ? Icons.check_circle_rounded : Icons.info_rounded,
                color: correct ? AppColors.success : AppColors.error,
                size: 18,
              ),
              AppSpacing.w8,
              Text(
                correct ? 'Correct!' : 'Incorrect',
                style: AppTextStyles.labelMedium.copyWith(
                  color: correct ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppSpacing.h8,
          Text(
            result.explanation,
            style: AppTextStyles.bodySmall.copyWith(
              color: correct ? AppColors.success : AppColors.error,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
