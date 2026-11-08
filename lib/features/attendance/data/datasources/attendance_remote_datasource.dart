import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/attendance/data/models/attendance_models.dart';
import 'package:dio/dio.dart';

class AttendanceRemoteDatasource {
  const AttendanceRemoteDatasource(this._dio);

  final Dio _dio;

  Future<AttendanceCheckInResult> checkIn(String token) async {
    try {
      final response = await _dio.post(
        ApiConstants.attendanceCheckIn,
        data: {'token': token},
      );
      _assertOk(response);
      return AttendanceCheckInResult.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<List<CourseAttendanceSummary>> getMySummary() async {
    try {
      final response = await _dio.get(ApiConstants.attendanceMySummary);
      _assertOk(response);
      final list = response.data as List<dynamic>? ?? [];
      return list
          .map((item) => CourseAttendanceSummary.fromJson(item as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  void _assertOk(Response<dynamic> response) {
    final code = response.statusCode ?? 500;
    if (code >= 200 && code < 300) return;

    final data = response.data;
    final message = data is Map && data['detail'] is String
        ? data['detail'] as String
        : 'فشلت عملية التحضير (HTTP $code)';
    throw NetworkException(message: message, statusCode: code);
  }
}
