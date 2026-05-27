import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:dio/dio.dart';

class AnnounRemoteDatasource {
  const AnnounRemoteDatasource(this._dio);
  final Dio _dio;

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<Announcement>> getAnnouncements({
    String? announcementType,
    String? priority,
    bool unreadOnly = false,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.announcements,
        queryParameters: {
          if (announcementType != null) 'announcement_type': announcementType,
          if (priority != null) 'priority': priority,
          if (unreadOnly) 'unread_only': true,
          if (search != null && search.isNotEmpty) 'search': search,
          'skip': skip,
          'limit': limit,
        },
      );
      _assertOk(response);
      return (response.data as List)
          .map((j) => Announcement.fromJson(j as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<List<Announcement>> getSentAnnouncements({
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.announcementsSent,
        queryParameters: {'skip': skip, 'limit': limit},
      );
      _assertOk(response);
      return (response.data as List)
          .map((j) => Announcement.fromJson(j as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiConstants.announcementsUnreadCount);
      _assertOk(response);
      return response.data['unread_count'] as int;
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<Announcement> getAnnouncementDetail(int id) async {
    try {
      final response = await _dio.get(ApiConstants.announcementById(id));
      _assertOk(response);
      return Announcement.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<List<RecipientUser>> getRecipients({
    String? role,
    String? courseId,
    String? department,
    String? search,
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.announcementsRecipients,
        queryParameters: {
          if (role != null) 'role': role,
          if (courseId != null) 'course_id': courseId,
          if (department != null) 'department': department,
          if (search != null && search.isNotEmpty) 'search': search,
          'skip': skip,
          'limit': limit,
        },
      );
      _assertOk(response);
      return (response.data as List)
          .map((j) => RecipientUser.fromJson(j as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<Announcement> createAnnouncement(
    Map<String, dynamic> payload, {
    List<MultipartFile> files = const [],
    List<String> linkUrls = const [],
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.announcements,
        data: payload,
      );
      _assertOk(response);
      return Announcement.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<Announcement> updateAnnouncement(
    int id,
    Map<String, dynamic> payload, {
    List<MultipartFile> files = const [],
    List<String> linkUrls = const [],
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.announcementById(id),
        data: payload,
      );
      _assertOk(response);
      return Announcement.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<void> deleteAnnouncement(int id) async {
    try {
      await _dio.delete(ApiConstants.announcementById(id));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<void> markRead(int id) async {
    try {
      await _dio.post(ApiConstants.announcementMarkRead(id));
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
