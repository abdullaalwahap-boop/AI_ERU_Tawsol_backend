import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:dio/dio.dart';

/// Low-level HTTP calls for all authentication endpoints.
///
/// Every public method either returns a value or throws a [NetworkException].
/// Higher layers (repository, cubit) catch that exception and map it to
/// domain-level failures or display messages.
class AuthRemoteDatasource {
  const AuthRemoteDatasource({
    required Dio dio,
    required SecureStorageService storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorageService _storage;

  // ─── Login ────────────────────────────────────────────────────────────────────

  /// Returns the authenticated [AuthUserModel] and persists the access token.
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      _assertOk(response);

      final data = response.data as Map<String, dynamic>;
      final token = data['access_token'] as String;
      final userJson = data['user'] as Map<String, dynamic>;
      final user = AuthUserModel.fromJson(userJson);

      // Persist token and user identity.
      await Future.wait([
        _storage.saveAccessToken(token),
        _storage.saveUserId(user.userId),
        _storage.saveUserType(user.typeCode),
      ]);

      return user;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────────────────

  /// Blacklists the current JWT on the server, then wipes local storage.
  Future<void> logout() async {
    try {
      // Best-effort: even if the server call fails we still clear locally.
      await _dio.post(ApiConstants.logout);
    } on DioException catch (_) {
      // Intentionally swallowed – local session must always be cleared.
    } finally {
      await _storage.clearAll();
    }
  }

  // ─── Forgot Password ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await _dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
      _assertOk(response);
      return response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Verify OTP ───────────────────────────────────────────────────────────────

  /// Returns the short-lived `reset_token` used in the next step.
  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: {'email': email, 'otp': otp},
      );
      _assertOk(response);

      final data = response.data as Map<String, dynamic>;
      return data['reset_token'] as String;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Reset Password ───────────────────────────────────────────────────────────

  /// Uses the `reset_token` returned by [verifyOtp].
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: {'reset_token': resetToken, 'new_password': newPassword},
      );
      _assertOk(response);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Change Password (authenticated) ─────────────────────────────────────────

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.changePassword,
        data: {
          'old_password': currentPassword,
          'new_password': newPassword,
        },
      );
      _assertOk(response);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────

  /// Throws [NetworkException] when the HTTP status is not in the 2xx range.
  void _assertOk(Response response) {
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
