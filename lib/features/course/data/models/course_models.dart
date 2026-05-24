import 'package:flutter/material.dart' show Color;

// ---------- Enums ----------

enum CourseRole { student, doctor }

enum ContentType { announcement, material, assignment }

enum ContentFileType { pdf, image, doc, other }

// ---------- Data Classes ----------

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

  String get initials {
    final words = name.trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }
}

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
      'Dec'
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
}
