/// Sealed hierarchy of WebSocket events emitted by [ChatWebSocketService].
///
/// Each case maps directly to a `"type"` field in the backend's JSON protocol.
sealed class WsEvent {}

/// Fired once on successful connection — carries all currently-online user IDs.
class WsConnectedEvent extends WsEvent {
  final int userId;
  final List<int> onlineUsers;

  WsConnectedEvent({required this.userId, required this.onlineUsers});
}

/// An incoming message from another user.
final class WsMessageReceivedEvent extends WsEvent {
  final Map<String, dynamic> data;

  WsMessageReceivedEvent(this.data);
}

/// Server confirmation that *our* sent message was persisted.
/// Contains the real [chat_id] to replace the optimistic temp ID.
final class WsMessageSentEvent extends WsEvent {
  final Map<String, dynamic> data;

  WsMessageSentEvent(this.data);
}

/// Typing indicator from another user.
final class WsTypingEvent extends WsEvent {
  final int senderId;
  final bool isTyping;

  WsTypingEvent({required this.senderId, required this.isTyping});
}

/// The partner has read our messages (all messages now "seen").
final class WsSeenEvent extends WsEvent {
  /// ID of the user who just read the messages (our partner).
  final int receiverId;

  WsSeenEvent(this.receiverId);
}

/// Our message was delivered to the partner's device.
final class WsDeliveredEvent extends WsEvent {
  final int receiverId;

  WsDeliveredEvent(this.receiverId);
}

/// A server-side error event.
final class WsErrorEvent extends WsEvent {
  final String detail;

  WsErrorEvent(this.detail);
}
