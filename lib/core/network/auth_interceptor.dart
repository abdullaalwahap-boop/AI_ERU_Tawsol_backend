import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:dio/dio.dart';

/// Injects the Bearer token into every request and handles global 401 responses.
///
/// On 401: clears storage + session so the user is sent back to login
/// automatically on the next navigation check.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final publicPaths = {
      ApiConstants.login,
      ApiConstants.forgotPassword,
      ApiConstants.verifyOtp,
      ApiConstants.resetPassword,
    };

    if (!publicPaths.contains(options.path)) {
      final token = await _storage.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // DioClient uses validateStatus < 500, so 401 arrives here as a response.
    if (response.statusCode == 401) {
      _handleExpiredSession();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _handleExpiredSession();
    }
    handler.next(err);
  }

  void _handleExpiredSession() {
    _storage.clearAll();
    getIt<SessionCubit>().clear();
  }
}
