import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/explanation_card.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/option_tile.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuizAttempt attempt;
  final int questionNumber;
  final int totalQuestions;
  final void Function(String key) onOptionSelected;
  final VoidCallback onNext;

  const QuizQuestionCard({
    super.key,
    required this.attempt,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onOptionSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final result = attempt.result;
    final isAnswered = attempt.isAnswered;
    final isLast = questionNumber == totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question $questionNumber of $totalQuestions',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: context.colorTextSecondary),
                  ),
                  Text(
                    '${((questionNumber - 1) / totalQuestions * 100).round()}%',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.accent),
                  ),
                ],
              ),
              AppSpacing.h8,
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (questionNumber - 1) / totalQuestions,
                  backgroundColor: context.colorBorder,
                  color: AppColors.accent,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.h20,

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colorSurface,
            borderRadius: AppRadius.xlarge,
            boxShadow: AppShadows.card,
          ),
          child: Text(
            attempt.question.question,
            style: AppTextStyles.titleMedium
                .copyWith(color: context.colorTextPrimary, height: 1.5),
          ),
        ),
        AppSpacing.h16,

        ...['A', 'B', 'C', 'D'].map(
          (key) => OptionTile(
            optionKey: key,
            text: attempt.question.options[key],
            isSelected: attempt.selectedAnswer == key,
            isAnswered: isAnswered,
            result: result,
            onTap: isAnswered ? null : () => onOptionSelected(key),
          ),
        ),

        if (isAnswered && result != null) ...[
          AppSpacing.h12,
          ExplanationCard(result: result),
        ],

        AppSpacing.h24,

        if (isAnswered)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.large),
              ),
              child: Text(
                isLast ? 'View Results' : 'Next Question',
                style: AppTextStyles.titleSmall
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
