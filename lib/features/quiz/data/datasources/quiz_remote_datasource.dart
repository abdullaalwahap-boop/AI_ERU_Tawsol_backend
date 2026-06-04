import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_models.dart';
import 'package:dio/dio.dart';

class QuizRemoteDatasource {
  const QuizRemoteDatasource(this._dio);

  final Dio _dio;

  Future<QuizSession> generateQuiz(int fileId) async {
    try {
      final response = await _dio.post(
        ApiConstants.quizGenerate,
        data: {'file_id': fileId},
        options: Options(receiveTimeout: const Duration(seconds: 180)),
      );
      _assertOk(response);
      return QuizSession.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<QuizAnswerResult> evaluateAnswer({
    required String sessionId,
    required int questionId,
    required String selected,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.quizEvaluate,
        data: {
          'session_id': sessionId,
          'question_id': questionId,
          'selected': selected,
        },
      );
      _assertOk(response);
      return QuizAnswerResult.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  void _assertOk(Response<dynamic> response) {
    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw NetworkException.fromDioError(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
    }
  }
}
