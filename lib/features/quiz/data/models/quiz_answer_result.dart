class QuizAnswerResult {
  final bool correct;
  final String correctAnswer;
  final String explanation;
  final String? selectedAnswer;

  const QuizAnswerResult({
    required this.correct,
    required this.correctAnswer,
    required this.explanation,
    this.selectedAnswer,
  });

  factory QuizAnswerResult.fromJson(Map<String, dynamic> json) =>
      QuizAnswerResult(
        correct: json['correct'] as bool,
        correctAnswer: json['correct_answer'] as String,
        explanation: json['explanation'] as String,
      );
}
