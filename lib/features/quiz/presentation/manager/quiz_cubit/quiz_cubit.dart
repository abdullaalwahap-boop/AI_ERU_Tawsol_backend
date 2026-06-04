import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';
import 'package:ai_eru_tawasol/features/quiz/data/repos/quiz_repo.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit(this._repo) : super(QuizInitial());

  final QuizRepo _repo;

  Future<void> generateQuiz(int fileId) async {
    emit(QuizGenerating());
    try {
      final session = await _repo.generateQuiz(fileId);
      final attempts =
          session.questions.map((q) => QuizAttempt(question: q)).toList();
      emit(QuizReady(sessionId: session.sessionId, attempts: attempts));
    } catch (e) {
      emit(QuizError(_friendlyError(e)));
    }
  }

  Future<void> submitAnswer(String selected) async {
    final current = state;
    if (current is! QuizReady) return;
    if (current.isCurrentAnswered) return;

    emit(QuizEvaluating(current));

    try {
      final result = await _repo.evaluateAnswer(
        sessionId: current.sessionId,
        questionId: current.currentAttempt.question.id,
        selected: selected,
      );

      final updatedResult = QuizAnswerResult(
        correct: result.correct,
        correctAnswer: result.correctAnswer,
        explanation: result.explanation,
        selectedAnswer: selected,
      );

      final updatedAttempt = current.currentAttempt.copyWith(
        selectedAnswer: selected,
        result: updatedResult,
      );

      emit(current.withUpdatedAttempt(current.currentIndex, updatedAttempt));
    } catch (e) {
      emit(QuizError(_friendlyError(e)));
    }
  }

  void nextQuestion() {
    final current = state;
    if (current is! QuizReady) return;
    if (!current.isCurrentAnswered) return;

    if (current.isLastQuestion) {
      emit(QuizFinished(current.attempts));
    } else {
      emit(current.withIndex(current.currentIndex + 1));
    }
  }

  void goToQuestion(int index) {
    final current = state;
    if (current is! QuizReady) return;
    emit(current.withIndex(index));
  }

  void retakeQuiz(int fileId) => generateQuiz(fileId);

  String _friendlyError(Object e) {
    final msg = e.toString();

    // Rate limit (Gemini free tier)
    if (msg.contains('rate limit') ||
        msg.contains('quota') ||
        msg.contains('429')) {
      return 'AI rate limit reached. Please wait a minute and try again.';
    }
    // AI service down / timeout
    if (msg.contains('503') ||
        msg.contains('not running') ||
        msg.contains('504') ||
        msg.contains('timed out')) {
      return 'AI service is unavailable. Please try again later.';
    }
    // Session expired
    if (msg.contains('session') || msg.contains('404')) {
      return 'Quiz session expired. Please generate a new quiz.';
    }
    // Server returned a descriptive detail — show it directly.
    // NetworkException.toString() returns the server detail string, not a status code.
    if (msg.isNotEmpty &&
        !msg.contains('Exception') &&
        !msg.contains('Error')) {
      return msg;
    }

    return 'Could not generate quiz. Please try again.';
  }
}
