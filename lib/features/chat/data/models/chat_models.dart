import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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

enum UserRole { student, doctor, admin }

extension UserRoleExt on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.doctor:
        return 'Doctor';
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
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }
}

enum MessageStatus { sending, sent, delivered, seen }

enum MessageType { text, image, voice, file }

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
  });
}

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
}

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
