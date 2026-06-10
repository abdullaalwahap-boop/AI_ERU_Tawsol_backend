import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── QuizOption ────────────────────────────────────────────────────────────

  group('QuizOption.fromJson', () {
    const json = {'A': 'Option A', 'B': 'Option B', 'C': 'Option C', 'D': 'Option D'};

    test('parses all options', () {
      final opt = QuizOption.fromJson(json);
      expect(opt.a, 'Option A');
      expect(opt.b, 'Option B');
      expect(opt.c, 'Option C');
      expect(opt.d, 'Option D');
    });

    test('subscript operator works for A/B/C/D', () {
      final opt = QuizOption.fromJson(json);
      expect(opt['A'], 'Option A');
      expect(opt['B'], 'Option B');
      expect(opt['C'], 'Option C');
      expect(opt['D'], 'Option D');
    });

    test('subscript operator is case-insensitive', () {
      final opt = QuizOption.fromJson(json);
      expect(opt['a'], 'Option A');
      expect(opt['b'], 'Option B');
    });

    test('subscript operator returns empty string for unknown key', () {
      final opt = QuizOption.fromJson(json);
      expect(opt['E'], '');
      expect(opt['Z'], '');
    });
  });

  // ── QuizQuestion ──────────────────────────────────────────────────────────

  group('QuizQuestion.fromJson', () {
    final json = {
      'id': 1,
      'question': 'What is 2+2?',
      'options': {'A': '3', 'B': '4', 'C': '5', 'D': '6'},
    };

    test('parses question correctly', () {
      final q = QuizQuestion.fromJson(json);
      expect(q.id, 1);
      expect(q.question, 'What is 2+2?');
      expect(q.options.b, '4');
    });
  });

  // ── QuizSession ───────────────────────────────────────────────────────────

  group('QuizSession.fromJson', () {
    final json = {
      'session_id': 'abc-123',
      'file_id': 7,
      'questions': [
        {
          'id': 1,
          'question': 'Q1?',
          'options': {'A': 'a1', 'B': 'b1', 'C': 'c1', 'D': 'd1'},
        },
        {
          'id': 2,
          'question': 'Q2?',
          'options': {'A': 'a2', 'B': 'b2', 'C': 'c2', 'D': 'd2'},
        },
      ],
    };

    test('parses session fields', () {
      final session = QuizSession.fromJson(json);
      expect(session.sessionId, 'abc-123');
      expect(session.fileId, 7);
      expect(session.questions.length, 2);
    });

    test('parses questions correctly', () {
      final session = QuizSession.fromJson(json);
      expect(session.questions[0].id, 1);
      expect(session.questions[1].question, 'Q2?');
    });

    test('empty questions list', () {
      final emptyJson = {...json, 'questions': <dynamic>[]};
      final session = QuizSession.fromJson(emptyJson);
      expect(session.questions, isEmpty);
    });
  });

  // ── QuizAnswerResult ──────────────────────────────────────────────────────

  group('QuizAnswerResult.fromJson', () {
    final json = {
      'correct': true,
      'correct_answer': 'B',
      'explanation': 'Because 2+2=4',
    };

    test('parses correct answer result', () {
      final result = QuizAnswerResult.fromJson(json);
      expect(result.correct, true);
      expect(result.correctAnswer, 'B');
      expect(result.explanation, 'Because 2+2=4');
    });

    test('parses incorrect answer result', () {
      final incorrectJson = {
        'correct': false,
        'correct_answer': 'A',
        'explanation': 'The answer is A',
      };
      final result = QuizAnswerResult.fromJson(incorrectJson);
      expect(result.correct, false);
      expect(result.correctAnswer, 'A');
    });
  });

  // ── QuizAttempt ───────────────────────────────────────────────────────────

  group('QuizAttempt', () {
    final question = QuizQuestion(
      id: 1,
      question: 'Test Q?',
      options: QuizOption(a: 'A', b: 'B', c: 'C', d: 'D'),
    );

    test('isAnswered is false when selectedAnswer is null', () {
      final attempt = QuizAttempt(question: question);
      expect(attempt.isAnswered, false);
    });

    test('isAnswered is true when selectedAnswer is set', () {
      final attempt =
          QuizAttempt(question: question, selectedAnswer: 'A');
      expect(attempt.isAnswered, true);
    });

    test('copyWith updates selectedAnswer', () {
      final attempt = QuizAttempt(question: question);
      final updated = attempt.copyWith(selectedAnswer: 'B');
      expect(updated.selectedAnswer, 'B');
      expect(updated.question, question);
    });

    test('copyWith updates result', () {
      final attempt = QuizAttempt(question: question, selectedAnswer: 'A');
      final result = QuizAnswerResult(
        correct: true,
        correctAnswer: 'A',
        explanation: 'Correct!',
      );
      final updated = attempt.copyWith(result: result);
      expect(updated.result, result);
      expect(updated.selectedAnswer, 'A');
    });
  });
}
