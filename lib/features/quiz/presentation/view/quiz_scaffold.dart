import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_args.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_cubit.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_state.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/quiz_error_view.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/quiz_generating_view.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/quiz_question_card.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/widgets/quiz_result_view.dart';

class QuizScaffold extends StatelessWidget {
  final QuizArgs args;
  const QuizScaffold({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBackground,
      appBar: AppBar(
        backgroundColor: context.colorSurface,
        elevation: 0,
        leading: BackButton(color: AppColors.primary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).quiz,
                style: AppTextStyles.titleMedium
                    .copyWith(color: AppColors.primary)),
            Text(
              args.lectureTitle,
              style: AppTextStyles.labelSmall
                  .copyWith(color: context.colorTextSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state is QuizGenerating) return const QuizGeneratingView();
          if (state is QuizError) {
            return QuizErrorView(
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
          if (ready == null) return const QuizGeneratingView();

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
