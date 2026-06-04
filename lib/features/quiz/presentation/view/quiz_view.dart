import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/quiz/data/repos/quiz_repo.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_cubit.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_state.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/quiz_question_card.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/quiz_result_view.dart';

class QuizArgs {
  final int fileId;
  final String lectureTitle;

  const QuizArgs({required this.fileId, required this.lectureTitle});
}

class QuizView extends StatelessWidget {
  final QuizArgs args;

  const QuizView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(getIt<QuizRepo>())..generateQuiz(args.fileId),
      child: _QuizScaffold(args: args),
    );
  }
}

class _QuizScaffold extends StatelessWidget {
  final QuizArgs args;
  const _QuizScaffold({required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        leading: BackButton(color: AppColors.primary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quiz',
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.primary)),
            Text(
              args.lectureTitle,
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state is QuizGenerating) return _GeneratingView();
          if (state is QuizError) {
            return _ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<QuizCubit>().retakeQuiz(args.fileId),
            );
          }
          if (state is QuizFinished) {
            return QuizResultView(
              attempts: state.attempts,
              onRetake: () =>
                  context.read<QuizCubit>().retakeQuiz(args.fileId),
              onExit: () => Navigator.of(context).pop(),
            );
          }

          final ready = state is QuizReady
              ? state
              : (state is QuizEvaluating ? state.base : null);
          if (ready == null) return _GeneratingView();

          final isEvaluating = state is QuizEvaluating;

          return AbsorbPointer(
            absorbing: isEvaluating,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: QuizQuestionCard(
                    attempt: ready.currentAttempt,
                    questionNumber: ready.currentIndex + 1,
                    totalQuestions: ready.totalQuestions,
                    onOptionSelected: (key) =>
                        context.read<QuizCubit>().submitAnswer(key),
                    onNext: () => context.read<QuizCubit>().nextQuestion(),
                  ),
                ),
                if (isEvaluating)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GeneratingView extends StatelessWidget {
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
              'Generating your quiz…',
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              'The AI is reading the lecture and creating\n10 questions just for you.',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorView({required this.message, this.onRetry});

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
              'Could not generate quiz',
              style: AppTextStyles.heading4
                  .copyWith(color: AppColors.textPrimary),
            ),
            AppSpacing.h8,
            Text(
              message,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Go Back'),
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
                    label: const Text('Try Again'),
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
