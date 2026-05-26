import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// ─── Chat Colors ──────────────────────────────────────────────────────────────

/// All values delegate to AppColors — one source of truth.
abstract class ChatColors {
  static const Color primary = AppColors.primary;
  static const Color primaryDark = AppColors.primaryDark;
  static const Color accent = AppColors.accent;
  static const Color background = AppColors.backgroundLight;
  static const Color surface = AppColors.surfaceLight;
  static const Color sentBubble = AppColors.sentBubble;
  static const Color receivedBubble = AppColors.receivedBubble;
  static const Color sentText = AppColors.sentBubbleText;
  static const Color receivedText = AppColors.receivedBubbleText;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textHint = AppColors.textHint;
  static const Color divider = AppColors.dividerLight;
  static const Color online = AppColors.online;
  static const Color inputBg = AppColors.inputBgLight;
  static const Color cardShadow = Color(0x0D000000);
}

// ─── UserRole ─────────────────────────────────────────────────────────────────

enum UserRole { student, doctor, ta, admin }

extension UserRoleExt on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.ta:
        return 'Teaching Assistant';
      case UserRole.admin:
        return 'Admin';
    }
  }

  Color get color {
    switch (this) {
      case UserRole.student:
        return AppColors.roleStudent;
      case UserRole.doctor:
        return AppColors.roleDoctor;
      case UserRole.ta:
        return AppColors.contentTeal;
      case UserRole.admin:
        return AppColors.roleAdmin;
    }
  }

  Color get lightColor {
    switch (this) {
      case UserRole.student:
        return AppColors.roleStudentLight;
      case UserRole.doctor:
        return AppColors.roleDoctorLight;
      case UserRole.ta:
        return AppColors.contentTealLight;
      case UserRole.admin:
        return AppColors.roleAdminLight;
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.student:
        return Icons.school_rounded;
      case UserRole.doctor:
        return Icons.menu_book_rounded;
      case UserRole.ta:
        return Icons.assignment_ind_rounded;
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }

  /// Maps a backend type_code string (STU | DR | TA | ADM) to [UserRole].
  static UserRole fromTypeCode(String typeCode) {
    switch (typeCode.toUpperCase()) {
      case 'DR':
        return UserRole.doctor;
      case 'TA':
        return UserRole.ta;
      case 'ADM':
        return UserRole.admin;
      default:
        return UserRole.student;
    }
  }
}

// ─── MessageStatus ────────────────────────────────────────────────────────────

enum MessageStatus { sending, sent, delivered, seen }

extension MessageStatusExt on MessageStatus {
  static MessageStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'delivered':
        return MessageStatus.delivered;
      case 'seen':
        return MessageStatus.seen;
      default:
        return MessageStatus.sent;
    }
  }
}

// ─── MessageType ──────────────────────────────────────────────────────────────

enum MessageType { text, image, voice, file }

extension MessageTypeExt on MessageType {
  static MessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'voice':
        return MessageType.voice;
      case 'file':
        return MessageType.file;
      default:
        return MessageType.text;
    }
  }
}

// ─── ChatUser ─────────────────────────────────────────────────────────────────

class ChatUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final UserRole role;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? studentId;

  const ChatUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.role,
    this.isOnline = false,
    this.lastSeen,
    this.studentId,
  });

  /// Maps a backend [ConversationUserOut] JSON object.
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: (json['id'] as int).toString(),
      name: json['name'] as String,
      avatarUrl: json['profile_picture'] as String?,
      role: UserRoleExt.fromTypeCode(json['type_code'] as String? ?? 'STU'),
      isOnline: json['is_online'] as bool? ?? false,
      lastSeen: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'] as String)
          : null,
      studentId: json['student_id'] as String?,
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get statusText {
    if (isOnline) return 'Online';
    if (lastSeen != null) {
      final diff = DateTime.now().difference(lastSeen!);
      if (diff.inMinutes < 60) return 'Last seen ${diff.inMinutes}m ago';
      if (diff.inHours < 24) return 'Last seen ${diff.inHours}h ago';
      return 'Last seen ${diff.inDays}d ago';
    }
    return 'Offline';
  }
}

// ─── ChatMessage ──────────────────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String senderId;
  final MessageType type;
  final String? text;
  final String? fileUrl;
  final String? fileName;
  final double? fileSizeMB;
  final Duration? voiceDuration;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isFromMe;
  final bool isDeleted;
  final DateTime? editedAt;
  final String? replyToId;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.type,
    this.text,
    this.fileUrl,
    this.fileName,
    this.fileSizeMB,
    this.voiceDuration,
    required this.timestamp,
    required this.status,
    required this.isFromMe,
    this.isDeleted = false,
    this.editedAt,
    this.replyToId,
  });

  /// Returns true if the message can be edited by the sender (text only, within 15 min).
  bool get canEdit =>
      isFromMe &&
      type == MessageType.text &&
      !isDeleted &&
      DateTime.now().difference(timestamp).inMinutes < 15;

  /// Returns true if the message can be deleted by the sender (within 15 min).
  bool get canDelete =>
      isFromMe &&
      !isDeleted &&
      DateTime.now().difference(timestamp).inMinutes < 15;

  /// Maps a backend [MessageOut] JSON object.
  /// [myUserId] is used to determine [isFromMe].
  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {required int myUserId}) {
    final senderId = json['sender_id'] as int;
    final sizeBytes = json['file_size_bytes'] as int?;
    final voiceSecs = json['voice_duration_seconds'] as int?;
    return ChatMessage(
      id: (json['chat_id'] as int).toString(),
      senderId: senderId.toString(),
      // Backend field is content_type, not message_type.
      type: MessageTypeExt.fromString(
          json['content_type'] as String? ?? 'text'),
      text: json['message'] as String?,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSizeMB: sizeBytes != null ? sizeBytes / (1024 * 1024) : null,
      voiceDuration:
          voiceSecs != null ? Duration(seconds: voiceSecs) : null,
      timestamp: DateTime.parse(json['sent_at'] as String),
      status: MessageStatusExt.fromString(
          json['status'] as String? ?? 'sent'),
      isFromMe: senderId == myUserId,
      isDeleted: json['is_deleted'] as bool? ?? false,
      editedAt: json['edited_at'] != null
          ? DateTime.tryParse(json['edited_at'] as String)
          : null,
      replyToId: (json['reply_to_id'] as int?)?.toString(),
    );
  }

  ChatMessage copyWith({
    MessageStatus? status,
    String? text,
    bool? isDeleted,
    DateTime? editedAt,
    String? fileUrl,
    String? fileName,
    Duration? voiceDuration,
    String? replyToId,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      type: type,
      text: text ?? this.text,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSizeMB: fileSizeMB,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      timestamp: timestamp,
      status: status ?? this.status,
      isFromMe: isFromMe,
      isDeleted: isDeleted ?? this.isDeleted,
      editedAt: editedAt ?? this.editedAt,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}

// ─── ChatConversation ─────────────────────────────────────────────────────────

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

  /// Maps a backend [ConversationOut] JSON object.
  factory ChatConversation.fromJson(Map<String, dynamic> json,
      {required int myUserId}) {
    return ChatConversation(
      id: json['id'] as String,
      otherUser: ChatUser.fromJson(
          json['other_user'] as Map<String, dynamic>),
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

// ─── AttachmentOption ─────────────────────────────────────────────────────────

enum AttachmentOption { camera, gallery, document, audio, link }

extension AttachmentOptionExt on AttachmentOption {
  String get label {
    switch (this) {
      case AttachmentOption.camera:
        return 'Camera';
      case AttachmentOption.gallery:
        return 'Gallery';
      case AttachmentOption.document:
        return 'Document';
      case AttachmentOption.audio:
        return 'Audio';
      case AttachmentOption.link:
        return 'Link';
    }
  }

  IconData get icon {
    switch (this) {
      case AttachmentOption.camera:
        return Icons.camera_alt_rounded;
      case AttachmentOption.gallery:
        return Icons.photo_library_rounded;
      case AttachmentOption.document:
        return Icons.picture_as_pdf_rounded;
      case AttachmentOption.audio:
        return Icons.audiotrack_rounded;
      case AttachmentOption.link:
        return Icons.link_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AttachmentOption.camera:
        return AppColors.roleStudent;
      case AttachmentOption.gallery:
        return AppColors.contentPurple;
      case AttachmentOption.document:
        return AppColors.roleAdmin;
      case AttachmentOption.audio:
        return AppColors.contentGreen;
      case AttachmentOption.link:
        return AppColors.contentTeal;
    }
  }
}
