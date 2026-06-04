import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizGenerating extends QuizState {}

class QuizReady extends QuizState {
  final String sessionId;
  final List<QuizAttempt> attempts;
  final int currentIndex;

  QuizReady({
    required this.sessionId,
    required this.attempts,
    this.currentIndex = 0,
  });

  QuizAttempt get currentAttempt => attempts[currentIndex];
  bool get isLastQuestion => currentIndex == attempts.length - 1;
  bool get isCurrentAnswered => currentAttempt.isAnswered;

  int get totalQuestions => attempts.length;
  int get answeredCount => attempts.where((a) => a.isAnswered).length;
  int get correctCount =>
      attempts.where((a) => a.result?.correct == true).length;

  QuizReady withUpdatedAttempt(int index, QuizAttempt updated) {
    final list = List<QuizAttempt>.from(attempts);
    list[index] = updated;
    return QuizReady(
      sessionId: sessionId,
      attempts: list,
      currentIndex: currentIndex,
    );
  }

  QuizReady withIndex(int index) => QuizReady(
        sessionId: sessionId,
        attempts: attempts,
        currentIndex: index,
      );
}

class QuizEvaluating extends QuizState {
  final QuizReady base;
  QuizEvaluating(this.base);
}

class QuizFinished extends QuizState {
  final List<QuizAttempt> attempts;
  QuizFinished(this.attempts);

  int get totalQuestions => attempts.length;
  int get correctCount =>
      attempts.where((a) => a.result?.correct == true).length;
  double get scorePercent =>
      totalQuestions == 0 ? 0 : correctCount / totalQuestions * 100;
}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}
