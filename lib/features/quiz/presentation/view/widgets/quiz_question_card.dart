import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';

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
        // ── Progress bar ─────────────────────────────────────────────────────
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
                        .copyWith(color: AppColors.textSecondary),
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
                  backgroundColor: AppColors.borderLight,
                  color: AppColors.accent,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.h20,

        // ── Question card ────────────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.xlarge,
            boxShadow: AppShadows.card,
          ),
          child: Text(
            attempt.question.question,
            style: AppTextStyles.titleMedium
                .copyWith(color: AppColors.textPrimary, height: 1.5),
          ),
        ),
        AppSpacing.h16,

        // ── Options ──────────────────────────────────────────────────────────
        ...['A', 'B', 'C', 'D'].map(
          (key) => _OptionTile(
            optionKey: key,
            text: attempt.question.options[key],
            isSelected: attempt.selectedAnswer == key,
            isAnswered: isAnswered,
            result: result,
            onTap: isAnswered ? null : () => onOptionSelected(key),
          ),
        ),

        // ── Explanation ──────────────────────────────────────────────────────
        if (isAnswered && result != null) ...[
          AppSpacing.h12,
          _ExplanationCard(result: result),
        ],

        AppSpacing.h24,

        // ── Next button ──────────────────────────────────────────────────────
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

class _OptionTile extends StatelessWidget {
  final String optionKey;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final QuizAnswerResult? result;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.optionKey,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = result?.correctAnswer == optionKey;
    final isWrong = isSelected && result?.correct == false;

    Color bg = AppColors.surfaceLight;
    Color border = AppColors.borderLight;
    Color labelBg = AppColors.backgroundLight;
    Color labelText = AppColors.textSecondary;
    Color textColor = AppColors.textPrimary;
    IconData? trailingIcon;

    if (isAnswered) {
      if (isCorrect) {
        bg = AppColors.successLight;
        border = AppColors.success;
        labelBg = AppColors.success;
        labelText = Colors.white;
        textColor = AppColors.success;
        trailingIcon = Icons.check_circle_rounded;
      } else if (isWrong) {
        bg = AppColors.errorLight;
        border = AppColors.error;
        labelBg = AppColors.error;
        labelText = Colors.white;
        textColor = AppColors.error;
        trailingIcon = Icons.cancel_rounded;
      }
    } else if (isSelected) {
      bg = AppColors.infoLight;
      border = AppColors.accent;
      labelBg = AppColors.accent;
      labelText = Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.large,
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: labelBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                optionKey,
                style: AppTextStyles.labelMedium.copyWith(
                  color: labelText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AppSpacing.w12,
            Expanded(
              child: Text(
                text,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: textColor),
              ),
            ),
            if (trailingIcon != null) ...[
              AppSpacing.w8,
              Icon(trailingIcon,
                  color: isCorrect ? AppColors.success : AppColors.error,
                  size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final QuizAnswerResult result;
  const _ExplanationCard({required this.result});

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
