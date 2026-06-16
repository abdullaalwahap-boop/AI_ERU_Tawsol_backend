import 'package:ai_eru_tawasol/features/chat/data/models/chat_message.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_user.dart';

class ChatConversation {
  final String id;
  final ChatUser otherUser;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isPinned;

  const ChatConversation({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    this.unreadCount = 0,
    this.isPinned = false,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json,
      {required int myUserId}) {
    return ChatConversation(
      id: json['id'] as String,
      otherUser:
          ChatUser.fromJson(json['other_user'] as Map<String, dynamic>),
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(
              json['last_message'] as Map<String, dynamic>,
              myUserId: myUserId,
            )
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      isPinned: json['is_pinned'] as bool? ?? false,
    );
  }

  ChatConversation copyWith({
    bool? isPinned,
    int? unreadCount,
    ChatMessage? lastMessage,
  }) {
    return ChatConversation(
      id: id,
      otherUser: otherUser,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
