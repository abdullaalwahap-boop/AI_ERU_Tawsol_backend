import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_answer_result.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_question.dart';

class QuizAttempt {
  final QuizQuestion question;
  final String? selectedAnswer;
  final QuizAnswerResult? result;

  const QuizAttempt({
    required this.question,
    this.selectedAnswer,
    this.result,
  });

  QuizAttempt copyWith({
    String? selectedAnswer,
    QuizAnswerResult? result,
  }) =>
      QuizAttempt(
        question: question,
        selectedAnswer: selectedAnswer ?? this.selectedAnswer,
        result: result ?? this.result,
      );

  bool get isAnswered => selectedAnswer != null;
}
