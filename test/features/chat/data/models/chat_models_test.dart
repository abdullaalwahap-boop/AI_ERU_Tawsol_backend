import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _msgJson({
  int chatId = 1,
  int senderId = 10,
  String contentType = 'text',
  String? message = 'Hello',
  String status = 'sent',
  bool isDeleted = false,
  String? fileUrl,
  String? fileName,
  int? fileSizeBytes,
  int? voiceDurationSeconds,
  int? replyToId,
  String? editedAt,
}) =>
    {
      'chat_id': chatId,
      'sender_id': senderId,
      'content_type': contentType,
      'message': message,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size_bytes': fileSizeBytes,
      'voice_duration_seconds': voiceDurationSeconds,
      'status': status,
      'sent_at': '2025-06-01T10:00:00',
      'is_deleted': isDeleted,
      'edited_at': editedAt,
      'reply_to_id': replyToId,
    };

void main() {
  // ── MessageStatus ─────────────────────────────────────────────────────────

  group('MessageStatusExt.fromString', () {
    test('parses "delivered"', () {
      expect(
        MessageStatusExt.fromString('delivered'),
        MessageStatus.delivered,
      );
    });
    test('parses "seen"', () {
      expect(MessageStatusExt.fromString('seen'), MessageStatus.seen);
    });
    test('defaults to sent for unknown value', () {
      expect(MessageStatusExt.fromString('anything'), MessageStatus.sent);
    });
  });

  // ── MessageType ───────────────────────────────────────────────────────────

  group('MessageTypeExt.fromString', () {
    test('parses "image"', () {
      expect(MessageTypeExt.fromString('image'), MessageType.image);
    });
    test('parses "voice"', () {
      expect(MessageTypeExt.fromString('voice'), MessageType.voice);
    });
    test('parses "file"', () {
      expect(MessageTypeExt.fromString('file'), MessageType.file);
    });
    test('defaults to text for unknown', () {
      expect(MessageTypeExt.fromString('anything'), MessageType.text);
    });
  });

  // ── UserRole ──────────────────────────────────────────────────────────────

  group('UserRoleExt.fromTypeCode', () {
    test('DR → doctor', () {
      expect(UserRoleExt.fromTypeCode('DR'), UserRole.doctor);
    });
    test('TA → ta', () {
      expect(UserRoleExt.fromTypeCode('TA'), UserRole.ta);
    });
    test('ADM → admin', () {
      expect(UserRoleExt.fromTypeCode('ADM'), UserRole.admin);
    });
    test('STU → student', () {
      expect(UserRoleExt.fromTypeCode('STU'), UserRole.student);
    });
    test('unknown → student', () {
      expect(UserRoleExt.fromTypeCode('XYZ'), UserRole.student);
    });
  });

  // ── ChatMessage ───────────────────────────────────────────────────────────

  group('ChatMessage.fromJson', () {
    test('parses text message correctly', () {
      final msg = ChatMessage.fromJson(_msgJson(), myUserId: 10);

      expect(msg.id, '1');
      expect(msg.senderId, '10');
      expect(msg.type, MessageType.text);
      expect(msg.text, 'Hello');
      expect(msg.status, MessageStatus.sent);
      expect(msg.isFromMe, true);
      expect(msg.isDeleted, false);
    });

    test('isFromMe is false when sender != myUserId', () {
      final msg = ChatMessage.fromJson(_msgJson(senderId: 99), myUserId: 10);
      expect(msg.isFromMe, false);
    });

    test('parses voice message with duration', () {
      final msg = ChatMessage.fromJson(
        _msgJson(contentType: 'voice', voiceDurationSeconds: 30),
        myUserId: 10,
      );
      expect(msg.type, MessageType.voice);
      expect(msg.voiceDuration, const Duration(seconds: 30));
    });

    test('parses file message with size', () {
      final msg = ChatMessage.fromJson(
        _msgJson(
          contentType: 'file',
          fileUrl: '/uploads/doc.pdf',
          fileName: 'doc.pdf',
          fileSizeBytes: 1048576,
        ),
        myUserId: 10,
      );
      expect(msg.type, MessageType.file);
      expect(msg.fileName, 'doc.pdf');
      expect(msg.fileSizeMB, closeTo(1.0, 0.01));
    });

    test('parses replyToId as string', () {
      final msg =
          ChatMessage.fromJson(_msgJson(replyToId: 7), myUserId: 10);
      expect(msg.replyToId, '7');
    });

    test('parses editedAt when present', () {
      final msg = ChatMessage.fromJson(
        _msgJson(editedAt: '2025-06-01T11:00:00'),
        myUserId: 10,
      );
      expect(msg.editedAt, isNotNull);
    });

    test('isDeleted flag is parsed', () {
      final msg =
          ChatMessage.fromJson(_msgJson(isDeleted: true), myUserId: 10);
      expect(msg.isDeleted, true);
    });
  });

  group('ChatMessage.canEdit', () {
    test('returns true for recent own text message', () {
      final recent = DateTime.now().subtract(const Duration(minutes: 5));
      final json = {
        ..._msgJson(senderId: 10, contentType: 'text'),
        'sent_at': recent.toIso8601String(),
      };
      final msg = ChatMessage.fromJson(json, myUserId: 10);
      expect(msg.canEdit, true);
    });

    test('returns false for old message', () {
      final old = DateTime.now().subtract(const Duration(minutes: 20));
      final json = {
        ..._msgJson(senderId: 10, contentType: 'text'),
        'sent_at': old.toIso8601String(),
      };
      final msg = ChatMessage.fromJson(json, myUserId: 10);
      expect(msg.canEdit, false);
    });

    test('returns false for non-text type', () {
      final recent = DateTime.now().subtract(const Duration(minutes: 2));
      final json = {
        ..._msgJson(senderId: 10, contentType: 'voice'),
        'sent_at': recent.toIso8601String(),
      };
      final msg = ChatMessage.fromJson(json, myUserId: 10);
      expect(msg.canEdit, false);
    });

    test('returns false for deleted message', () {
      final recent = DateTime.now().subtract(const Duration(minutes: 2));
      final json = {
        ..._msgJson(senderId: 10, isDeleted: true),
        'sent_at': recent.toIso8601String(),
      };
      final msg = ChatMessage.fromJson(json, myUserId: 10);
      expect(msg.canEdit, false);
    });
  });

  group('ChatMessage.copyWith', () {
    final msg = ChatMessage.fromJson(_msgJson(), myUserId: 10);

    test('updates status', () {
      final updated = msg.copyWith(status: MessageStatus.seen);
      expect(updated.status, MessageStatus.seen);
      expect(updated.id, msg.id);
    });

    test('updates text', () {
      final updated = msg.copyWith(text: 'Updated text');
      expect(updated.text, 'Updated text');
    });

    test('updates isDeleted', () {
      final updated = msg.copyWith(isDeleted: true);
      expect(updated.isDeleted, true);
      expect(updated.type, msg.type);
    });
  });

  // ── ChatUser ──────────────────────────────────────────────────────────────

  group('ChatUser.fromJson', () {
    final userJson = {
      'id': 5,
      'name': 'Ahmed Ali',
      'type_code': 'STU',
      'is_online': true,
      'last_seen': null,
      'student_id': '225040',
      'profile_picture': null,
    };

    test('parses user correctly', () {
      final user = ChatUser.fromJson(userJson);
      expect(user.id, '5');
      expect(user.name, 'Ahmed Ali');
      expect(user.role, UserRole.student);
      expect(user.isOnline, true);
      expect(user.studentId, '225040');
    });

    test('initials for two-word name', () {
      final user = ChatUser.fromJson(userJson);
      expect(user.initials, 'AA');
    });

    test('initials for single-word name', () {
      final json = Map<String, dynamic>.from(userJson)..['name'] = 'Ahmed';
      expect(ChatUser.fromJson(json).initials, 'A');
    });

    test('statusText returns Online when online', () {
      final user = ChatUser.fromJson(userJson);
      expect(user.statusText, 'Online');
    });

    test('statusText returns Offline when offline with no lastSeen', () {
      final json = Map<String, dynamic>.from(userJson)
        ..['is_online'] = false
        ..['last_seen'] = null;
      expect(ChatUser.fromJson(json).statusText, 'Offline');
    });
  });

  // ── ChatConversation ──────────────────────────────────────────────────────

  group('ChatConversation.fromJson', () {
    final convJson = {
      'id': '10_20',
      'other_user': {
        'id': 20,
        'name': 'Dr. Waleed',
        'type_code': 'DR',
        'is_online': false,
        'last_seen': null,
        'student_id': null,
      },
      'last_message': null,
      'unread_count': 3,
      'is_pinned': true,
    };

    test('parses conversation', () {
      final conv = ChatConversation.fromJson(convJson, myUserId: 10);
      expect(conv.id, '10_20');
      expect(conv.otherUser.name, 'Dr. Waleed');
      expect(conv.unreadCount, 3);
      expect(conv.isPinned, true);
      expect(conv.lastMessage, isNull);
    });

    test('parses last message when present', () {
      final json = Map<String, dynamic>.from(convJson)
        ..['last_message'] = _msgJson(senderId: 20);
      final conv = ChatConversation.fromJson(json, myUserId: 10);
      expect(conv.lastMessage, isNotNull);
    });

    test('copyWith updates isPinned', () {
      final conv = ChatConversation.fromJson(convJson, myUserId: 10);
      final updated = conv.copyWith(isPinned: false);
      expect(updated.isPinned, false);
      expect(updated.id, conv.id);
    });
  });
}
