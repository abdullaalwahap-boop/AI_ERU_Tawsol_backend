class QuizOption {
  final String a;
  final String b;
  final String c;
  final String d;

  const QuizOption({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) => QuizOption(
        a: json['A'] as String,
        b: json['B'] as String,
        c: json['C'] as String,
        d: json['D'] as String,
      );

  String operator [](String key) {
    switch (key.toUpperCase()) {
      case 'A':
        return a;
      case 'B':
        return b;
      case 'C':
        return c;
      case 'D':
        return d;
      default:
        return '';
    }
  }
}

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

/// Tracks a student's attempt at a single question during a session.
class QuizAttempt {
  final QuizQuestion question;
  final String? selectedAnswer;      // null = not yet answered
  final QuizAnswerResult? result;    // null = not yet evaluated

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
