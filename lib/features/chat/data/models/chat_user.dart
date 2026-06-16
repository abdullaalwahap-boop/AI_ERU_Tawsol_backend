import 'package:ai_eru_tawasol/features/chat/data/models/user_role.dart';

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
