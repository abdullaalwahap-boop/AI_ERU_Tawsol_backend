import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:dio/dio.dart';

/// Remote data source for all chat-related REST API calls.
///
/// - Conversations  → GET /chat/conversations
/// - Message history → GET /chat/history/{u1}/{u2}
/// - Send message   → POST /chat/send  (fallback when WS is unavailable)
/// - User search    → GET /chat/search?q=
/// - Mark seen      → PUT /chat/seen/{other_user_id}
class ChatRemoteDatasource {
  const ChatRemoteDatasource({
    required Dio dio,
    required SecureStorageService storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorageService _storage;

  // ── Conversations ──────────────────────────────────────────────────────────

  Future<List<ChatConversation>> getConversations() async {
    final myId = await _requireUserId();
    try {
      final response = await _dio.get(ApiConstants.chatConversations);
      _assertOk(response);
      return (response.data as List)
          .map((j) => ChatConversation.fromJson(
                j as Map<String, dynamic>,
                myUserId: myId,
              ))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── Message History ────────────────────────────────────────────────────────

  Future<List<ChatMessage>> getMessages(
    String otherUserId, {
    int skip = 0,
    int limit = 50,
  }) async {
    final myId = await _requireUserId();
    final otherId = int.parse(otherUserId);
    try {
      final response = await _dio.get(
        ApiConstants.chatHistory(myId, otherId),
        queryParameters: {'skip': skip, 'limit': limit},
      );
      _assertOk(response);
      return (response.data as List)
          .map((j) =>
              ChatMessage.fromJson(j as Map<String, dynamic>, myUserId: myId))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── Send Message (REST fallback) ───────────────────────────────────────────

  Future<ChatMessage> sendMessage({
    required String receiverId,
    required String text,
    String messageType = 'text',
  }) async {
    final myId = await _requireUserId();
    try {
      final response = await _dio.post(
        ApiConstants.chatSend,
        data: {
          'receiver_id': int.parse(receiverId),
          'message': text,
          'message_type': messageType,
        },
      );
      _assertOk(response);
      return ChatMessage.fromJson(
        response.data as Map<String, dynamic>,
        myUserId: myId,
      );
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── User Search ────────────────────────────────────────────────────────────

  /// Searches users by name or student ID.
  /// Results are scoped by the backend's role-permission rules when the
  /// search endpoint is updated; currently returns globally matched users.
  Future<List<ChatUser>> searchUsers(String q) async {
    try {
      final response = await _dio.get(
        ApiConstants.chatSearch,
        queryParameters: {'q': q},
      );
      if ((response.statusCode ?? 0) >= 400) return const [];
      return (response.data as List)
          .map((j) => ChatUser.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException {
      return const [];
    }
  }

  // ── Mark Seen ──────────────────────────────────────────────────────────────

  Future<void> markSeen(String otherUserId) async {
    try {
      await _dio.put(ApiConstants.chatSeen(int.parse(otherUserId)));
    } on DioException {
      // Non-critical — best effort.
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<int> _requireUserId() async {
    final id = await _storage.getUserId();
    if (id == null) {
      throw const NetworkException('Session expired. Please log in again.');
    }
    return id;
  }

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
