import 'package:flutter/material.dart' show Color;

// ─── Enums ────────────────────────────────────────────────────────────────────

enum CourseRole { student, doctor }

enum ContentType { announcement, material, assignment }

enum ContentFileType {
  pdf,
  image,
  doc,
  other;

  /// Maps backend file_type strings to the frontend enum value.
  static ContentFileType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pdf':
        return ContentFileType.pdf;
      case 'image':
        return ContentFileType.image;
      case 'word':
      case 'ppt':
      case 'python':
      case 'jupyter':
        return ContentFileType.doc;
      default:
        return ContentFileType.other;
    }
  }
}

// ─── Course (Material) ────────────────────────────────────────────────────────

class CourseDetailsArgs {
  final Course course;
  final CourseRole role;

  const CourseDetailsArgs({required this.course, required this.role});
}

class Course {
  final String id;
  final String name;
  final String code;
  final String doctorName;
  final String description;
  final Color accentColor;
  final int studentCount;
  final int contentCount;
  final int duration;

  const Course({
    required this.id,
    required this.name,
    required this.code,
    required this.doctorName,
    required this.description,
    required this.accentColor,
    required this.studentCount,
    required this.contentCount,
    this.duration = 0,
  });

  /// Maps a backend `MaterialOut` JSON object to a [Course].
  factory Course.fromJson(Map<String, dynamic> json) {
    final id = json['material_id'] as String;
    return Course(
      id: id,
      code: id,
      name: json['name'] as String,
      doctorName: json['teacher_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      accentColor: _accentColorFromId(id),
      studentCount: json['student_count'] as int? ?? 0,
      contentCount: json['content_count'] as int? ?? 0,
      duration: json['duration'] as int? ?? 0,
    );
  }

  String get initials {
    final words = name.trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  /// Deterministic accent color derived from the material_id so the same
  /// course always renders with the same color across sessions.
  static Color _accentColorFromId(String id) {
    const colors = [
      Color(0xff3D6FFF),
      Color(0xff7C3AED),
      Color(0xff059669),
      Color(0xffEA580C),
      Color(0xff0891B2),
      Color(0xffF59E0B),
      Color(0xffEF4444),
      Color(0xff10B981),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }
}

// ─── Course Content ───────────────────────────────────────────────────────────

class ContentAttachment {
  final String name;
  final String sizeLabel;
  final ContentFileType fileType;

  const ContentAttachment({
    required this.name,
    required this.sizeLabel,
    required this.fileType,
  });
}

class CourseContent {
  final String id;
  final String title;
  final String body;
  final ContentType type;
  final DateTime createdAt;
  final List<ContentAttachment> attachments;
  final bool isFromAdmin;
  final String authorName;

  const CourseContent({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.attachments = const [],
    this.isFromAdmin = false,
    required this.authorName,
  });

  // ── Backend factories ──────────────────────────────────────────────────────

  /// Maps a backend `AnnouncementOut` JSON object.
  /// Only call with announcements where `announcement_type == 'normal'`.
  factory CourseContent.fromAnnouncement(Map<String, dynamic> json) {
    return CourseContent(
      id: (json['announcement_id'] as int).toString(),
      title: json['title'] as String,
      body: json['content'] as String,
      type: ContentType.announcement,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorName: json['author_name'] as String? ?? '',
      attachments: const [],
      isFromAdmin: false,
    );
  }

  /// Maps a backend `AssignmentOut` JSON object.
  factory CourseContent.fromAssignment(Map<String, dynamic> json) {
    final fileType = json['file_type'] as String?;
    final filePath = json['file_path'] as String?;
    final linkUrl = json['link_url'] as String?;
    final title = json['title'] as String;

    final List<ContentAttachment> attachments;
    if (filePath != null) {
      attachments = [
        ContentAttachment(
          name: title,
          sizeLabel: (fileType ?? 'file').toUpperCase(),
          fileType: ContentFileType.fromString(fileType),
        ),
      ];
    } else if (linkUrl != null) {
      attachments = const [
        ContentAttachment(
          name: 'Open Link',
          sizeLabel: 'URL',
          fileType: ContentFileType.other,
        ),
      ];
    } else {
      attachments = const [];
    }

    return CourseContent(
      id: (json['assignment_id'] as int).toString(),
      title: title,
      body: _assignmentBody(json),
      type: ContentType.assignment,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorName: '',
      attachments: attachments,
      isFromAdmin: false,
    );
  }

  /// Maps a backend `MaterialFileOut` JSON object.
  factory CourseContent.fromFile(Map<String, dynamic> json) {
    final fileType = json['file_type'] as String? ?? 'other';
    final filePath = json['file_path'] as String?;
    final linkUrl = json['link_url'] as String?;
    final title = json['title'] as String;

    final List<ContentAttachment> attachments;
    if (filePath != null) {
      attachments = [
        ContentAttachment(
          name: title,
          sizeLabel: fileType.toUpperCase(),
          fileType: ContentFileType.fromString(fileType),
        ),
      ];
    } else if (linkUrl != null) {
      attachments = const [
        ContentAttachment(
          name: 'Open Link',
          sizeLabel: 'URL',
          fileType: ContentFileType.other,
        ),
      ];
    } else {
      attachments = [
        ContentAttachment(
          name: title,
          sizeLabel: fileType.toUpperCase(),
          fileType: ContentFileType.fromString(fileType),
        ),
      ];
    }

    return CourseContent(
      id: (json['file_id'] as int).toString(),
      title: title,
      body: json['description'] as String? ??
          json['text_content'] as String? ??
          '',
      type: ContentType.material,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorName: '',
      attachments: attachments,
      isFromAdmin: false,
    );
  }

  // ── Display helpers ────────────────────────────────────────────────────────

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formattedDate;
  }

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }

  String get formattedTime {
    final h = createdAt.hour;
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String get authorInitials {
    final parts = authorName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return authorName.isNotEmpty ? authorName[0].toUpperCase() : '?';
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  static String _assignmentBody(Map<String, dynamic> json) {
    final parts = <String>[];

    final desc = json['description'] as String?;
    if (desc != null && desc.isNotEmpty) parts.add(desc);

    final text = json['text_content'] as String?;
    if (text != null && text.isNotEmpty) parts.add(text);

    final deadlineStr = json['deadline'] as String?;
    if (deadlineStr != null) {
      final dl = DateTime.tryParse(deadlineStr)?.toLocal();
      if (dl != null) {
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        parts.add('Deadline: ${months[dl.month - 1]} ${dl.day}, ${dl.year}');
      }
    }

    return parts.join('\n\n');
  }
}
