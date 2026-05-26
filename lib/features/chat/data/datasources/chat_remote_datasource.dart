import 'package:ai_eru_tawasol/core/errors/network_exception.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/voice_upload_result.dart';
import 'package:dio/dio.dart';

/// Remote data source for all chat-related REST API calls.
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
    String contentType = 'text',
  }) async {
    final myId = await _requireUserId();
    try {
      final response = await _dio.post(
        ApiConstants.chatSend,
        data: {
          'receiver_id': int.parse(receiverId),
          'message': text,
          'content_type': contentType,
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

  // ── Edit Message ───────────────────────────────────────────────────────────

  Future<ChatMessage> editMessage(int chatId, String newText) async {
    final myId = await _requireUserId();
    try {
      final response = await _dio.put(
        ApiConstants.chatMessage(chatId),
        data: {'message': newText},
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

  // ── Delete Message ─────────────────────────────────────────────────────────

  Future<void> deleteMessage(int chatId) async {
    try {
      final response =
          await _dio.delete(ApiConstants.chatMessage(chatId));
      _assertOk(response);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── User Search ────────────────────────────────────────────────────────────

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

  // ── Voice Upload ──────────────────────────────────────────────────────────

  Future<VoiceUploadResult> uploadVoiceFile(String filePath) async {
    final fileName = filePath.split(RegExp(r'[/\\]')).last;
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final response = await _dio.post(
        ApiConstants.chatUploadVoice,
        data: formData,
      );
      _assertOk(response);
      return VoiceUploadResult.fromJson(
          response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // ── Pin / Unpin ────────────────────────────────────────────────────────────

  Future<void> pinConversation(int partnerId) async {
    try {
      await _dio.post(ApiConstants.chatPin(partnerId));
    } on DioException {
      rethrow;
    }
  }

  Future<void> unpinConversation(int partnerId) async {
    try {
      await _dio.delete(ApiConstants.chatPin(partnerId));
    } on DioException {
      rethrow;
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
