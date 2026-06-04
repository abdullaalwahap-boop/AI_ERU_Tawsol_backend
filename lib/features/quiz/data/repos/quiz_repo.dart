import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';

abstract class QuizRepo {
  Future<QuizSession> generateQuiz(int fileId);

  Future<QuizAnswerResult> evaluateAnswer({
    required String sessionId,
    required int questionId,
    required String selected,
  });
}
