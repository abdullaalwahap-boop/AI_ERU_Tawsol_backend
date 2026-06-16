import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_question.dart';

class QuizSession {
  final String sessionId;
  final int fileId;
  final List<QuizQuestion> questions;

  const QuizSession({
    required this.sessionId,
    required this.fileId,
    required this.questions,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) => QuizSession(
        sessionId: json['session_id'] as String,
        fileId: json['file_id'] as int,
        questions: (json['questions'] as List)
            .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}
