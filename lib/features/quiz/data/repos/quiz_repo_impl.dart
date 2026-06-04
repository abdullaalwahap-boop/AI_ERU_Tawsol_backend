import 'package:ai_eru_tawasol/features/quiz/data/datasources/quiz_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';
import 'package:ai_eru_tawasol/features/quiz/data/repos/quiz_repo.dart';

class QuizRepoImpl implements QuizRepo {
  const QuizRepoImpl(this._datasource);

  final QuizRemoteDatasource _datasource;

  @override
  Future<QuizSession> generateQuiz(int fileId) =>
      _datasource.generateQuiz(fileId);

  @override
  Future<QuizAnswerResult> evaluateAnswer({
    required String sessionId,
    required int questionId,
    required String selected,
  }) =>
      _datasource.evaluateAnswer(
        sessionId: sessionId,
        questionId: questionId,
        selected: selected,
      );
}
