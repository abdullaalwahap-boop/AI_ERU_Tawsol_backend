import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/review_tile.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/score_ring.dart';

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
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: context.colorSurface,
            borderRadius: AppRadius.xlarge,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).quizComplete,
                  style: AppTextStyles.heading3
                      .copyWith(color: context.colorTextPrimary)),
              AppSpacing.h20,
              ScoreRing(percent: _pct, color: scoreColor),
              AppSpacing.h16,
              Text(
                AppLocalizations.of(context).quizScore(_correct, _total),
                style: AppTextStyles.titleLarge
                    .copyWith(color: context.colorTextPrimary),
              ),
              AppSpacing.h6,
              Text(
                pctInt >= 80
                    ? AppLocalizations.of(context).quizExcellent
                    : pctInt >= 60
                        ? AppLocalizations.of(context).quizGoodEffort
                        : AppLocalizations.of(context).quizKeepStudying,
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
                      child: Text(AppLocalizations.of(context).exit,
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
                      child: Text(AppLocalizations.of(context).retakeQuiz,
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
        Text(AppLocalizations.of(context).reviewAnswers,
            style: AppTextStyles.titleLarge
                .copyWith(color: context.colorTextPrimary)),
        AppSpacing.h12,

        ...attempts.asMap().entries.map((e) => ReviewTile(
              number: e.key + 1,
              attempt: e.value,
            )),
      ],
    );
  }
}
