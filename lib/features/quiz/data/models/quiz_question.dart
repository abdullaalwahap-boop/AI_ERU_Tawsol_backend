import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_option.dart';

class QuizQuestion {
  final int id;
  final String question;
  final QuizOption options;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json['id'] as int,
        question: json['question'] as String,
        options: QuizOption.fromJson(json['options'] as Map<String, dynamic>),
      );
}
