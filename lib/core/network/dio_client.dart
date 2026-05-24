import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/network/auth_interceptor.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

/// Single Dio instance shared across the app.
///
/// Configured with:
/// - JSON content-type header
/// - connect / receive timeouts
/// - [AuthInterceptor] for token injection and 401 handling
class DioClient {
  DioClient(SecureStorageService storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.add(AuthInterceptor(storage));
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
