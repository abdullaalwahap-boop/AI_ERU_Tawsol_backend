import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_ws_events.dart';

/// Manages a single persistent WebSocket connection for the authenticated user.
///
/// Registered as a singleton in the service locator so both [ChatCubit] and
/// [PrivateChatCubit] share the same connection and event stream.
///
/// Protocol: ws(s)://host/chat/ws/{userId}?token={jwt}
class ChatWebSocketService {
  ChatWebSocketService(this._storage);

  final SecureStorageService _storage;

  WebSocket? _socket;
  StreamSubscription? _socketSub;
  int? _connectedUserId;

  final StreamController<WsEvent> _controller =
      StreamController<WsEvent>.broadcast();

  /// Broadcast stream of typed [WsEvent]s.
  /// Both cubits subscribe to this stream and filter by partner ID.
  Stream<WsEvent> get events => _controller.stream;

  bool get isConnected =>
      _socket != null &&
      _socket!.readyState == WebSocket.open &&
      _connectedUserId != null;

  // ── Connection lifecycle ───────────────────────────────────────────────────

  /// Connects if not already connected as the current user.
  /// If connected as a different user (e.g. after logout/login), disconnects first.
  Future<void> ensureConnected() async {
    final userId = await _storage.getUserId();
    final token = await _storage.getAccessToken();
    if (userId == null || token == null) return;
    if (isConnected && _connectedUserId == userId) return;
    if (isConnected) disconnect();
    await _connect(userId, token);
  }

  Future<void> _connect(int userId, String token) async {
    try {
      final url = '${ApiConstants.wsChat(userId)}?token=$token';
      _socket = await WebSocket.connect(url);
      _connectedUserId = userId;

      _socketSub = _socket!.listen(
        _handleRawEvent,
        onDone: _handleDisconnect,
        onError: (_) => _handleDisconnect(),
        cancelOnError: false,
      );
    } catch (_) {
      _socket = null;
      _connectedUserId = null;
    }
  }

  void _handleDisconnect() {
    _socket = null;
    _connectedUserId = null;
  }

  /// Closes the WebSocket. Call on logout or app disposal.
  void disconnect() {
    _socketSub?.cancel();
    _socketSub = null;
    _socket?.close();
    _socket = null;
    _connectedUserId = null;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }

  // ── Outgoing messages ──────────────────────────────────────────────────────

  void sendText({
    required int receiverId,
    required String text,
    int? replyToId,
  }) {
    _send({
      'type': 'message',
      'receiver_id': receiverId,
      'message': text,
      'content_type': 'text',
      if (replyToId != null) 'reply_to_id': replyToId,
    });
  }

  void sendVoice({
    required int receiverId,
    required int durationSeconds,
    String? fileUrl,
    String? fileName,
    int? fileSizeBytes,
    int? replyToId,
  }) {
    _send({
      'type': 'message',
      'receiver_id': receiverId,
      'content_type': 'voice',
      'voice_duration_seconds': durationSeconds,
      if (fileUrl != null) 'file_url': fileUrl,
      if (fileName != null) 'file_name': fileName,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (replyToId != null) 'reply_to_id': replyToId,
    });
  }

  void sendFile({
    required int receiverId,
    required String contentType, // 'image' | 'audio' | 'file'
    required String fileUrl,
    required String fileName,
    required int fileSizeBytes,
    int? replyToId,
  }) {
    _send({
      'type': 'message',
      'receiver_id': receiverId,
      'content_type': contentType,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size_bytes': fileSizeBytes,
      if (replyToId != null) 'reply_to_id': replyToId,
    });
  }

  void sendTyping({required int receiverId, required bool isTyping}) {
    _send({
      'type': 'typing',
      'receiver_id': receiverId,
      'is_typing': isTyping,
    });
  }

  /// Notify the backend that all messages from [senderId] have been read.
  void sendSeen(int senderId) {
    _send({'type': 'seen', 'sender_id': senderId});
  }

  void _send(Map<String, dynamic> payload) {
    if (!isConnected) return;
    _socket!.add(jsonEncode(payload));
  }

  // ── Incoming event parsing ─────────────────────────────────────────────────

  void _handleRawEvent(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = data['type'] as String? ?? '';

      final WsEvent? event = switch (type) {
        'connected' => WsConnectedEvent(
            userId: data['user_id'] as int,
            onlineUsers: List<int>.from(data['online_users'] as List? ?? []),
          ),
        'message' => WsMessageReceivedEvent(data),
        'sent' => WsMessageSentEvent(data),
        'typing' => WsTypingEvent(
            senderId: data['sender_id'] as int,
            isTyping: data['is_typing'] as bool? ?? false,
          ),
        'seen' => WsSeenEvent(data['receiver_id'] as int),
        'delivered' => WsDeliveredEvent(data['receiver_id'] as int),
        'message_edited' => WsMessageEditedEvent(
            chatId: data['chat_id'] as int,
            newText: data['message'] as String? ?? '',
            editedAt: data['edited_at'] as String? ?? '',
          ),
        'message_deleted' => WsMessageDeletedEvent(data['chat_id'] as int),
        'error' =>
          WsErrorEvent(data['detail'] as String? ?? 'Unknown WS error'),
        _ => null,
      };

      if (event != null) _controller.add(event);
    } catch (_) {
      // Malformed frame — silently ignore.
    }
  }
}
