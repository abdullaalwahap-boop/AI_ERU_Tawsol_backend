import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:dio/dio.dart';

/// Remote data source for all course-related API calls.
///
/// - Course lists  → GET /materials/student/{id}  or  /materials/teacher/{id}
/// - Course content → parallel fetch of announcements, assignments, and files
///                   merged into a unified [CourseContent] list sorted newest-first.
class CourseRemoteDatasource {
  const CourseRemoteDatasource({
    required Dio dio,
    required SecureStorageService storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorageService _storage;

  // ── Course Lists ───────────────────────────────────────────────────────────

  Future<List<Course>> getStudentCourses() => _fetchCourses(student: true);

  Future<List<Course>> getTeacherCourses() => _fetchCourses(student: false);

  Future<List<Course>> _fetchCourses({required bool student}) async {
    final userId = await _storage.getUserId();
    if (userId == null) {
      throw const NetworkException('Session expired. Please log in again.');
    }
    try {
      final path = student
          ? ApiConstants.studentMaterials(userId)
          : ApiConstants.teacherMaterials(userId);
      final response = await _dio.get(path);
      _assertOk(response);
      return (response.data as List)
          .map((j) => Course.fromJson(j as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── Course Content ─────────────────────────────────────────────────────────

  /// Fetches all content for [materialId] in parallel (announcements that
  /// target this course + all assignments + all files), merges the lists, and
  /// returns them sorted by [CourseContent.createdAt] descending.
  Future<List<CourseContent>> getCourseContent(String materialId) async {
    try {
      final results = await Future.wait([
        _fetchCourseAnnouncements(materialId),
        _fetchAssignments(materialId),
        _fetchFiles(materialId),
      ]);

      final merged = [...results[0], ...results[1], ...results[2]];
      merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return merged;
    } on NetworkException {
      rethrow;
    } catch (_) {
      throw const NetworkException('Failed to load course content.');
    }
  }

  // ── Private fetchers ───────────────────────────────────────────────────────

  /// Fetches the authenticated user's announcements and returns only those
  /// that target [materialId] with type "normal" (pure announcements, not
  /// assignment/file notifications which are fetched via dedicated endpoints).
  Future<List<CourseContent>> _fetchCourseAnnouncements(
      String materialId) async {
    try {
      final response = await _dio.get(ApiConstants.announcements);
      if ((response.statusCode ?? 0) >= 400) return const [];
      return (response.data as List)
          .where((j) =>
              j['target_course_id'] == materialId &&
              j['announcement_type'] == 'normal')
          .map((j) => CourseContent.fromAnnouncement(j as Map<String, dynamic>))
          .toList();
    } on DioException {
      return const [];
    }
  }

  Future<List<CourseContent>> _fetchAssignments(String materialId) async {
    try {
      final response =
          await _dio.get(ApiConstants.courseAssignments(materialId));
      if ((response.statusCode ?? 0) >= 400) return const [];
      return (response.data as List)
          .map((j) =>
              CourseContent.fromAssignment(j as Map<String, dynamic>))
          .toList();
    } on DioException {
      return const [];
    }
  }

  Future<List<CourseContent>> _fetchFiles(String materialId) async {
    try {
      final response = await _dio.get(ApiConstants.courseFiles(materialId));
      if ((response.statusCode ?? 0) >= 400) return const [];
      return (response.data as List)
          .map((j) => CourseContent.fromFile(j as Map<String, dynamic>))
          .toList();
    } on DioException {
      return const [];
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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
