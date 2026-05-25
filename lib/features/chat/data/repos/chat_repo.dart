import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';

abstract class ChatRepo {
  /// Returns all conversations for the authenticated user, pinned first.
  Future<List<ChatConversation>> getConversations();

  /// Returns message history with [otherUserId], ordered oldest → newest.
  Future<List<ChatMessage>> getMessages(String otherUserId);

  /// Searches for users the current user is permitted to chat with.
  Future<List<ChatUser>> searchUsers(String q);

  /// Marks all messages from [otherUserId] as seen (REST fallback).
  Future<void> markSeen(String otherUserId);
}
