import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';
import 'package:ai_eru_tawasol/features/quiz/data/repos/quiz_repo.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_cubit.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockQuizRepo extends Mock implements QuizRepo {}

QuizQuestion _q(int id) => QuizQuestion(
      id: id,
      question: 'Question $id?',
      options: const QuizOption(a: 'Opt A', b: 'Opt B', c: 'Opt C', d: 'Opt D'),
    );

QuizSession _session(int count) => QuizSession(
      sessionId: 'sess-abc',
      fileId: 42,
      questions: List.generate(count, (i) => _q(i + 1)),
    );

QuizAnswerResult _result({bool correct = true}) => QuizAnswerResult(
      correct: correct,
      correctAnswer: 'A',
      explanation: 'Because A is correct.',
    );

QuizReady _readyState({int count = 2, int index = 0}) => QuizReady(
      sessionId: 'sess-abc',
      currentIndex: index,
      attempts: List.generate(count, (i) => QuizAttempt(question: _q(i + 1))),
    );

QuizReady _answeredState({int count = 2, int index = 0, bool correct = true}) {
  final attempts = List.generate(count, (i) {
    if (i == index) {
      return QuizAttempt(
        question: _q(i + 1),
        selectedAnswer: 'A',
        result: _result(correct: correct),
      );
    }
    return QuizAttempt(question: _q(i + 1));
  });
  return QuizReady(sessionId: 'sess-abc', currentIndex: index, attempts: attempts);
}

void main() {
  late _MockQuizRepo repo;

  setUp(() => repo = _MockQuizRepo());

  group('QuizCubit', () {
    test('initial state is QuizInitial', () {
      expect(QuizCubit(repo).state, isA<QuizInitial>());
    });

    // ── generateQuiz ────────────────────────────────────────────────────────

    group('generateQuiz', () {
      blocTest<QuizCubit, QuizState>(
        'emits [QuizGenerating, QuizReady] on success',
        build: () {
          when(() => repo.generateQuiz(any()))
              .thenAnswer((_) async => _session(3));
          return QuizCubit(repo);
        },
        act: (c) => c.generateQuiz(42),
        expect: () => [
          isA<QuizGenerating>(),
          isA<QuizReady>()
              .having((s) => s.totalQuestions, 'totalQuestions', 3)
              .having((s) => s.currentIndex, 'currentIndex', 0)
              .having((s) => s.sessionId, 'sessionId', 'sess-abc'),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'emits QuizError with rate-limit message on 429',
        build: () {
          when(() => repo.generateQuiz(any()))
              .thenThrow(Exception('429 rate limit exceeded'));
          return QuizCubit(repo);
        },
        act: (c) => c.generateQuiz(42),
        expect: () => [
          isA<QuizGenerating>(),
          isA<QuizError>().having((s) => s.message, 'msg',
              contains('rate limit')),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'emits QuizError with unavailable message on 503',
        build: () {
          when(() => repo.generateQuiz(any()))
              .thenThrow(Exception('503 service not running'));
          return QuizCubit(repo);
        },
        act: (c) => c.generateQuiz(42),
        expect: () => [
          isA<QuizGenerating>(),
          isA<QuizError>().having((s) => s.message, 'msg',
              contains('unavailable')),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'emits QuizError with session-expired message when response contains session',
        build: () {
          when(() => repo.generateQuiz(any()))
              .thenThrow(Exception('quiz session not found'));
          return QuizCubit(repo);
        },
        act: (c) => c.generateQuiz(42),
        expect: () => [
          isA<QuizGenerating>(),
          isA<QuizError>().having((s) => s.message, 'msg',
              contains('expired')),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'emits QuizError with fallback message on unknown exception',
        build: () {
          when(() => repo.generateQuiz(any()))
              .thenThrow(Exception('Something completely unknown'));
          return QuizCubit(repo);
        },
        act: (c) => c.generateQuiz(42),
        expect: () => [
          isA<QuizGenerating>(),
          isA<QuizError>().having((s) => s.message, 'msg',
              contains('generate quiz')),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'retakeQuiz re-runs generateQuiz',
        build: () {
          when(() => repo.generateQuiz(any()))
              .thenAnswer((_) async => _session(2));
          return QuizCubit(repo);
        },
        act: (c) => c.retakeQuiz(42),
        expect: () => [isA<QuizGenerating>(), isA<QuizReady>()],
        verify: (_) => verify(() => repo.generateQuiz(42)).called(1),
      );
    });

    // ── submitAnswer ─────────────────────────────────────────────────────────

    group('submitAnswer', () {
      blocTest<QuizCubit, QuizState>(
        'emits [QuizEvaluating, QuizReady] with result on success',
        build: () {
          when(() => repo.evaluateAnswer(
                sessionId: any(named: 'sessionId'),
                questionId: any(named: 'questionId'),
                selected: any(named: 'selected'),
              )).thenAnswer((_) async => _result(correct: true));
          return QuizCubit(repo);
        },
        seed: () => _readyState(),
        act: (c) => c.submitAnswer('A'),
        expect: () => [
          isA<QuizEvaluating>(),
          isA<QuizReady>().having(
            (s) => s.currentAttempt.result?.correct,
            'result.correct',
            true,
          ),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'QuizEvaluating carries the current QuizReady as base',
        build: () {
          when(() => repo.evaluateAnswer(
                sessionId: any(named: 'sessionId'),
                questionId: any(named: 'questionId'),
                selected: any(named: 'selected'),
              )).thenAnswer((_) async => _result());
          return QuizCubit(repo);
        },
        seed: () => _readyState(),
        act: (c) => c.submitAnswer('A'),
        expect: () => [
          isA<QuizEvaluating>().having(
            (s) => s.base.sessionId,
            'base.sessionId',
            'sess-abc',
          ),
          isA<QuizReady>(),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'does nothing when question is already answered',
        build: () => QuizCubit(repo),
        seed: () => _answeredState(),
        act: (c) => c.submitAnswer('B'),
        expect: () => [],
      );

      blocTest<QuizCubit, QuizState>(
        'does nothing when state is not QuizReady',
        build: () => QuizCubit(repo),
        seed: () => QuizGenerating(),
        act: (c) => c.submitAnswer('A'),
        expect: () => [],
      );

      blocTest<QuizCubit, QuizState>(
        'emits [QuizEvaluating, QuizError] when evaluation fails',
        build: () {
          when(() => repo.evaluateAnswer(
                sessionId: any(named: 'sessionId'),
                questionId: any(named: 'questionId'),
                selected: any(named: 'selected'),
              )).thenThrow(Exception('404 session'));
          return QuizCubit(repo);
        },
        seed: () => _readyState(),
        act: (c) => c.submitAnswer('A'),
        expect: () => [
          isA<QuizEvaluating>(),
          isA<QuizError>().having((s) => s.message, 'msg', contains('expired')),
        ],
      );
    });

    // ── nextQuestion ──────────────────────────────────────────────────────────

    group('nextQuestion', () {
      blocTest<QuizCubit, QuizState>(
        'advances to next index when not last question',
        build: () => QuizCubit(repo),
        seed: () => _answeredState(count: 3, index: 0),
        act: (c) => c.nextQuestion(),
        expect: () => [
          isA<QuizReady>().having((s) => s.currentIndex, 'index', 1),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'emits QuizFinished when last question is answered',
        build: () => QuizCubit(repo),
        seed: () {
          final attempts = [
            QuizAttempt(
              question: _q(1),
              selectedAnswer: 'A',
              result: _result(correct: true),
            ),
            QuizAttempt(
              question: _q(2),
              selectedAnswer: 'B',
              result: _result(correct: false),
            ),
          ];
          return QuizReady(
              sessionId: 'sess-abc', currentIndex: 1, attempts: attempts);
        },
        act: (c) => c.nextQuestion(),
        expect: () => [
          isA<QuizFinished>()
              .having((s) => s.totalQuestions, 'total', 2)
              .having((s) => s.correctCount, 'correct', 1)
              .having((s) => s.scorePercent, 'percent', 50.0),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'does nothing when current question is not answered',
        build: () => QuizCubit(repo),
        seed: () => _readyState(),
        act: (c) => c.nextQuestion(),
        expect: () => [],
      );
    });

    // ── goToQuestion ──────────────────────────────────────────────────────────

    group('goToQuestion', () {
      blocTest<QuizCubit, QuizState>(
        'changes currentIndex',
        build: () => QuizCubit(repo),
        seed: () => _readyState(count: 3),
        act: (c) => c.goToQuestion(2),
        expect: () => [
          isA<QuizReady>().having((s) => s.currentIndex, 'index', 2),
        ],
      );
    });
  });

  // ── QuizReady computed getters ─────────────────────────────────────────────

  group('QuizReady computed getters', () {
    test('isLastQuestion: false when not at end', () {
      final s = QuizReady(
          sessionId: 's',
          attempts: [QuizAttempt(question: _q(1)), QuizAttempt(question: _q(2))]);
      expect(s.isLastQuestion, false);
    });

    test('isLastQuestion: true when at last index', () {
      final s = QuizReady(
          sessionId: 's',
          currentIndex: 1,
          attempts: [QuizAttempt(question: _q(1)), QuizAttempt(question: _q(2))]);
      expect(s.isLastQuestion, true);
    });

    test('isCurrentAnswered: false when no selection', () {
      expect(_readyState().isCurrentAnswered, false);
    });

    test('isCurrentAnswered: true when selectedAnswer is set', () {
      expect(_answeredState().isCurrentAnswered, true);
    });

    test('answeredCount counts only answered attempts', () {
      final s = QuizReady(sessionId: 's', attempts: [
        QuizAttempt(
            question: _q(1), selectedAnswer: 'A', result: _result()),
        QuizAttempt(question: _q(2)),
        QuizAttempt(
            question: _q(3), selectedAnswer: 'C', result: _result(correct: false)),
      ]);
      expect(s.answeredCount, 2);
    });

    test('correctCount counts only correct results', () {
      final s = QuizReady(sessionId: 's', attempts: [
        QuizAttempt(
            question: _q(1), selectedAnswer: 'A', result: _result(correct: true)),
        QuizAttempt(
            question: _q(2), selectedAnswer: 'B', result: _result(correct: false)),
        QuizAttempt(
            question: _q(3), selectedAnswer: 'A', result: _result(correct: true)),
      ]);
      expect(s.correctCount, 2);
    });

    test('withUpdatedAttempt replaces attempt at given index', () {
      final original = _readyState(count: 2);
      final updated = original.withUpdatedAttempt(
          0,
          QuizAttempt(
              question: _q(1),
              selectedAnswer: 'D',
              result: _result(correct: false)));
      expect(updated.attempts[0].selectedAnswer, 'D');
      expect(updated.attempts[1].selectedAnswer, null);
    });

    test('withIndex creates new state with different index', () {
      final s = _readyState(count: 3);
      final moved = s.withIndex(2);
      expect(moved.currentIndex, 2);
      expect(moved.sessionId, s.sessionId);
    });
  });

  // ── QuizFinished computed getters ─────────────────────────────────────────

  group('QuizFinished computed getters', () {
    test('scorePercent is 100 when all correct', () {
      final f = QuizFinished([
        QuizAttempt(
            question: _q(1), selectedAnswer: 'A', result: _result(correct: true)),
        QuizAttempt(
            question: _q(2), selectedAnswer: 'A', result: _result(correct: true)),
      ]);
      expect(f.scorePercent, 100.0);
      expect(f.correctCount, 2);
    });

    test('scorePercent is 0 when no questions', () {
      expect(QuizFinished([]).scorePercent, 0.0);
    });

    test('scorePercent is 50 when half correct', () {
      final f = QuizFinished([
        QuizAttempt(
            question: _q(1), selectedAnswer: 'A', result: _result(correct: true)),
        QuizAttempt(
            question: _q(2), selectedAnswer: 'B', result: _result(correct: false)),
      ]);
      expect(f.scorePercent, 50.0);
    });
  });
}
