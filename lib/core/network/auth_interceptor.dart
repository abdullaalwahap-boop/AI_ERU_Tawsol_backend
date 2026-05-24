import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

/// Injects the Bearer token into every request and handles global 401 responses.
///
/// On 401 the user's session is cleared. Navigation back to login is handled
/// by the individual feature layers (cubit catches the thrown [UnauthorizedException]).
class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for public endpoints.
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Let the datasource handle all errors uniformly.
    handler.next(err);
  }
}
