import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/assignment_model.dart';
import 'package:dio/dio.dart';

class AssignmentRemoteDatasource {
  const AssignmentRemoteDatasource(this._dio);
  final Dio _dio;

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<Assignment>> getAssignments({
    String? status, // upcoming | overdue | all
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.assignments,
        queryParameters: {
          if (status != null) 'status': status,
          'skip': skip,
          'limit': limit,
        },
      );
      _assertOk(response);
      return (response.data as List)
          .map((j) => Assignment.fromJson(j as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<List<Assignment>> getUpcoming({int days = 7}) async {
    try {
      final response = await _dio.get(
        ApiConstants.assignmentsUpcoming,
        queryParameters: {'days': days},
      );
      _assertOk(response);
      return (response.data as List)
          .map((j) => Assignment.fromJson(j as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<Assignment> getDetail(int id) async {
    try {
      final response = await _dio.get(ApiConstants.assignmentDetail(id));
      _assertOk(response);
      return Assignment.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<List<Assignment>> getCourseAssignments(String materialId) async {
    try {
      final response =
          await _dio.get(ApiConstants.courseAssignments(materialId));
      _assertOk(response);
      return (response.data as List)
          .map((j) => Assignment.fromJson(j as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<Assignment> createAssignment({
    required String materialId,
    required String title,
    String? description,
    required DateTime deadline,
    String? linkUrl,
    String? fileType,
    String? textContent,
    MultipartFile? file,
    int? announcementId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'material_id': materialId,
        'title': title,
        if (description != null) 'description': description,
        'deadline': deadline.toIso8601String(),
        if (linkUrl != null) 'link_url': linkUrl,
        if (fileType != null) 'file_type': fileType,
        if (textContent != null) 'text_content': textContent,
        if (file != null) 'file': file,
        if (announcementId != null) 'announcement_id': announcementId,
      });
      final response = await _dio.post(
        ApiConstants.assignments,
        data: formData,
      );
      _assertOk(response);
      return Assignment.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<Assignment> updateAssignment(
      int id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put(
        ApiConstants.assignmentById(id),
        data: payload,
      );
      _assertOk(response);
      return Assignment.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<void> deleteAssignment(int id) async {
    try {
      await _dio.delete(ApiConstants.assignmentById(id));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _assertOk(Response<dynamic> r) {
    final s = r.statusCode ?? 0;
    if (s < 200 || s >= 300) {
      throw NetworkException.fromDioError(DioException(
        requestOptions: r.requestOptions,
        response: r,
        type: DioExceptionType.badResponse,
      ));
    }
  }
}
