import 'package:dio/dio.dart';

/// Converts a raw [DioException] or any [Exception] into a human-readable
/// message suitable for display in UI error states.
///
/// Rule: only call [fromDioError] at the datasource boundary so that cubits
/// and repositories receive plain [Exception]s with clean messages.
class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;

  @override
  String toString() => message;

  // ─── Factory ─────────────────────────────────────────────────────────────────

  factory NetworkException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Connection timed out. Please check your internet and try again.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'Cannot reach the server. Make sure you are connected to the internet.',
        );

      case DioExceptionType.badResponse:
        return _fromResponse(e.response);

      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');

      default:
        return NetworkException(e.message ?? 'An unexpected error occurred.');
    }
  }

  static NetworkException _fromResponse(Response? response) {
    if (response == null) {
      return const NetworkException('Empty server response.');
    }

    // Try to extract FastAPI's {"detail": "..."} field.
    final data = response.data;
    String? detail;
    if (data is Map<String, dynamic>) {
      final raw = data['detail'];
      if (raw is String) detail = raw;
      if (raw is List && raw.isNotEmpty) {
        // Pydantic validation errors come as a list of objects.
        final first = raw.first;
        if (first is Map) detail = first['msg']?.toString();
      }
    }

    switch (response.statusCode) {
      case 400:
        return NetworkException(detail ?? 'Bad request.');
      case 401:
        return NetworkException(detail ?? 'Invalid email or password.');
      case 403:
        return NetworkException(detail ?? 'Access denied.');
      case 404:
        return NetworkException(detail ?? 'Resource not found.');
      case 409:
        return NetworkException(detail ?? 'Conflict with existing data.');
      case 422:
        return NetworkException(detail ?? 'Validation error.');
      case 500:
      case 502:
      case 503:
        return NetworkException(
          detail ?? 'Server error. Please try again later.',
        );
      default:
        return NetworkException(
          detail ?? 'Unexpected error (${response.statusCode}).',
        );
    }
  }
}
