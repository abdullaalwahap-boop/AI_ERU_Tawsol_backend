import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';

class QuizResultView extends StatelessWidget {
  final List<QuizAttempt> attempts;
  final VoidCallback onRetake;
  final VoidCallback onExit;

  const QuizResultView({
    super.key,
    required this.attempts,
    required this.onRetake,
    required this.onExit,
  });

  int get _correct => attempts.where((a) => a.result?.correct == true).length;
  int get _total => attempts.length;
  double get _pct => _total == 0 ? 0 : _correct / _total;

  @override
  Widget build(BuildContext context) {
    final pctInt = (_pct * 100).round();
    final Color scoreColor = _pct >= 0.8
        ? AppColors.success
        : _pct >= 0.5
            ? AppColors.warning
            : AppColors.error;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        // ── Score card ────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: context.colorSurface,
            borderRadius: AppRadius.xlarge,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              Text('Quiz Complete!',
                  style: AppTextStyles.heading3
                      .copyWith(color: context.colorTextPrimary)),
              AppSpacing.h20,
              _ScoreRing(percent: _pct, color: scoreColor),
              AppSpacing.h16,
              Text(
                '$_correct / $_total Correct',
                style: AppTextStyles.titleLarge
                    .copyWith(color: context.colorTextPrimary),
              ),
              AppSpacing.h6,
              Text(
                pctInt >= 80
                    ? 'Excellent work!'
                    : pctInt >= 60
                        ? 'Good effort — keep practicing!'
                        : 'Keep studying and try again!',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: context.colorTextSecondary),
              ),
              AppSpacing.h24,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onExit,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium),
                      ),
                      child: Text('Exit',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.primary)),
                    ),
                  ),
                  AppSpacing.w12,
                  Expanded(
                    child: FilledButton(
                      onPressed: onRetake,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium),
                      ),
                      child: Text('Retake Quiz',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        AppSpacing.h24,
        Text('Review Your Answers',
            style:
                AppTextStyles.titleLarge.copyWith(color: context.colorTextPrimary)),
        AppSpacing.h12,

        // ── Per-question review ───────────────────────────────────────────────
        ...attempts.asMap().entries.map((e) => _ReviewTile(
              number: e.key + 1,
              attempt: e.value,
            )),
      ],
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final double percent;
  final Color color;

  const _ScoreRing({required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 10,
              backgroundColor: context.colorBorder,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '${(percent * 100).round()}%',
            style: AppTextStyles.heading3.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final int number;
  final QuizAttempt attempt;

  const _ReviewTile({required this.number, required this.attempt});

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
