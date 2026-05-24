import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/contact_model.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:dio/dio.dart';

/// Low-level HTTP calls for all user/profile endpoints.
///
/// Every method either returns a value or throws a [NetworkException].
class ProfileRemoteDatasource {
  const ProfileRemoteDatasource(this._dio);

  final Dio _dio;

  // ─── Get Profile ──────────────────────────────────────────────────────────────

  Future<ProfileUser> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.me);
      _assertOk(response);

      final data = response.data as Map<String, dynamic>;
      return _parseUser(data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Update Name ──────────────────────────────────────────────────────────────

  Future<ProfileUser> updateName(String name) async {
    try {
      final response = await _dio.put(
        ApiConstants.me,
        data: {'name': name},
      );
      _assertOk(response);

      final data = response.data as Map<String, dynamic>;
      return _parseUser(data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Change Password ──────────────────────────────────────────────────────────

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

  // ─── Contact Us ───────────────────────────────────────────────────────────────

  Future<void> sendContactUs(ContactRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.contactUs,
        data: request.toJson(),
      );
      _assertOk(response);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────

  ProfileUser _parseUser(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['user_id'].toString(),
      uniCode: json['uni_code'] as String? ?? json['user_id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      role: _roleFromTypeCode(json['type_code'] as String),
      avatarUrl: json['profile_picture'] as String?,
      department: json['department'] as String? ?? '',
      level: json['level'] as int?,
    );
  }

  ProfileRole _roleFromTypeCode(String typeCode) {
    switch (typeCode.toUpperCase()) {
      case 'DR':
        return ProfileRole.doctor;
      case 'TA':
        return ProfileRole.ta;
      case 'ADM':
        return ProfileRole.admin;
      default:
        return ProfileRole.student;
    }
  }

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
