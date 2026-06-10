import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _dioEx(
  DioExceptionType type, {
  Response<dynamic>? response,
  String? message,
}) =>
    DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: type,
      response: response,
      message: message,
    );

Response<Map<String, dynamic>> _response(
  int statusCode, {
  Map<String, dynamic>? data,
}) =>
    Response(
      requestOptions: RequestOptions(path: '/test'),
      statusCode: statusCode,
      data: data,
    );

void main() {
  group('NetworkException', () {
    test('toString returns message', () {
      const ex = NetworkException('Test error');
      expect(ex.toString(), 'Test error');
    });
  });

  group('NetworkException.fromDioError', () {
    test('connectionTimeout → timeout message', () {
      final ex = NetworkException.fromDioError(
        _dioEx(DioExceptionType.connectionTimeout),
      );
      expect(ex.message, contains('timed out'));
    });

    test('sendTimeout → timeout message', () {
      final ex = NetworkException.fromDioError(
        _dioEx(DioExceptionType.sendTimeout),
      );
      expect(ex.message, contains('timed out'));
    });

    test('receiveTimeout → timeout message', () {
      final ex = NetworkException.fromDioError(
        _dioEx(DioExceptionType.receiveTimeout),
      );
      expect(ex.message, contains('timed out'));
    });

    test('connectionError → server unreachable message', () {
      final ex = NetworkException.fromDioError(
        _dioEx(DioExceptionType.connectionError),
      );
      expect(ex.message, contains('Cannot reach'));
    });

    test('cancel → request cancelled message', () {
      final ex = NetworkException.fromDioError(
        _dioEx(DioExceptionType.cancel),
      );
      expect(ex.message, contains('cancelled'));
    });

    test('unknown type → uses error message', () {
      final ex = NetworkException.fromDioError(
        _dioEx(DioExceptionType.unknown, message: 'Some error'),
      );
      expect(ex.message, 'Some error');
    });

    group('HTTP status codes', () {
      test('400 → bad request', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse,
              response: _response(400)),
        );
        expect(ex.message, contains('Bad request'));
      });

      test('401 → invalid credentials', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse,
              response: _response(401)),
        );
        expect(ex.message, contains('Invalid email'));
      });

      test('403 → access denied', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse,
              response: _response(403)),
        );
        expect(ex.message, contains('Access denied'));
      });

      test('404 → not found', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse,
              response: _response(404)),
        );
        expect(ex.message, contains('not found'));
      });

      test('409 → conflict', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse,
              response: _response(409)),
        );
        expect(ex.message, contains('Conflict'));
      });

      test('422 → validation error', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse,
              response: _response(422)),
        );
        expect(ex.message, contains('Validation'));
      });

      test('500 → server error', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse,
              response: _response(500)),
        );
        expect(ex.message, contains('Server error'));
      });

      test('extracts detail from FastAPI error body', () {
        final ex = NetworkException.fromDioError(
          _dioEx(
            DioExceptionType.badResponse,
            response: _response(
              401,
              data: {'detail': 'Custom error from server'},
            ),
          ),
        );
        expect(ex.message, 'Custom error from server');
      });

      test('extracts detail from Pydantic validation list', () {
        final ex = NetworkException.fromDioError(
          _dioEx(
            DioExceptionType.badResponse,
            response: _response(
              422,
              data: {
                'detail': [
                  {'msg': 'field required', 'type': 'missing'}
                ]
              },
            ),
          ),
        );
        expect(ex.message, 'field required');
      });

      test('null response → empty server response message', () {
        final ex = NetworkException.fromDioError(
          _dioEx(DioExceptionType.badResponse, response: null),
        );
        expect(ex.message, contains('Empty server response'));
      });
    });
  });
}
