// ---------- Enums ----------

enum AnnounRole { student, doctor, admin }

enum AnnouncementPriority {
  normal,
  important,
  urgent;

  static AnnouncementPriority fromString(String v) => switch (v) {
        'important' => important,
        'urgent' => urgent,
        _ => normal,
      };

  String get toApiString => switch (this) {
        important => 'important',
        urgent => 'urgent',
        normal => 'normal',
      };
}

enum AnnouncementType {
  normal,
  materialFile,
  assignment;

  static AnnouncementType fromString(String v) => switch (v) {
        'material_file' => materialFile,
        'assignment' => assignment,
        _ => normal,
      };

  String get toApiString => switch (this) {
        materialFile => 'material_file',
        assignment => 'assignment',
        normal => 'normal',
      };
}

enum AnnouncementTarget {
  all,
  course,
  courseDepartment,
  department,
  level,
  student,
  users;

  static AnnouncementTarget fromString(String v) => switch (v) {
        'course' => course,
        'course_department' => courseDepartment,
        'department' => department,
        'level' => level,
        'student' => student,
        'users' => users,
        _ => all,
      };

  String get toApiString => switch (this) {
        course => 'course',
        courseDepartment => 'course_department',
        department => 'department',
        level => 'level',
        student => 'student',
        users => 'users',
        all => 'all',
      };
}

extension AnnouncementTargetExt on AnnouncementTarget {
  String get label => switch (this) {
        AnnouncementTarget.all => 'All Students',
        AnnouncementTarget.course => 'Course',
        AnnouncementTarget.courseDepartment => 'Dept. Course',
        AnnouncementTarget.department => 'Department',
        AnnouncementTarget.level => 'Level',
        AnnouncementTarget.student => 'Student',
        AnnouncementTarget.users => 'Selected Users',
      };
}

enum AttachmentFileType { pdf, image, doc, other }

// ---------- Helper Models ----------

class CourseOption {
  final String id;
  final String name;
  final String? departmentCourse;

  const CourseOption({
    required this.id,
    required this.name,
    this.departmentCourse,
  });

  factory CourseOption.fromJson(Map<String, dynamic> json) => CourseOption(
        id: json['material_id'] as String,
        name: json['name'] as String,
        departmentCourse: json['department_course'] as String?,
      );

  String get displayName => '$name · $id';
}

class RecipientUser {
  final int userId;
  final String name;
  final String uniCode;
  final String typeCode;
  final String? department;
  final int? level;

  const RecipientUser({
    required this.userId,
    required this.name,
    required this.uniCode,
    required this.typeCode,
    this.department,
    this.level,
  });

  factory RecipientUser.fromJson(Map<String, dynamic> json) => RecipientUser(
        userId: json['user_id'] as int,
        name: json['name'] as String,
        uniCode: json['uni_code'] as String,
        typeCode: json['type_code'] as String,
        department: json['department'] as String?,
        level: json['level'] as int?,
      );
}

/// Passed as [state.extra] when navigating to the add/edit announcement screen.
class AddAnnounArgs {
  final AnnounRole role;
  final int userId;
  final Announcement? announcementToEdit;

  const AddAnnounArgs({
    required this.role,
    required this.userId,
    this.announcementToEdit,
  });
}

// ---------- Attachment ----------

class AnnounAttachment {
  final int? fileId;
  final String name;
  final String url;
  final double sizeMB;
  final AttachmentFileType fileType;

  const AnnounAttachment({
    this.fileId,
    required this.name,
    required this.url,
    required this.sizeMB,
    required this.fileType,
  });

  factory AnnounAttachment.fromJson(Map<String, dynamic> json) {
    // name: supports old format (file_name/name) and MaterialFileOut (title)
    final name = (json['file_name'] as String?) ??
        (json['name'] as String?) ??
        (json['title'] as String?) ??
        '';

    // url: link_url for links, file_path made absolute, then legacy fields
    final filePath = json['file_path'] as String?;
    final linkUrl = json['link_url'] as String?;
    final legacyUrl =
        (json['file_url'] as String?) ?? (json['url'] as String?);
    String url = '';
    if (linkUrl != null && linkUrl.isNotEmpty) {
      url = linkUrl;
    } else if (filePath != null && filePath.isNotEmpty) {
      url = filePath.startsWith('http')
          ? filePath
          : 'http://10.0.2.2:8000/$filePath';
    } else if (legacyUrl != null && legacyUrl.isNotEmpty) {
      url = legacyUrl;
    }

    final rawSize = json['file_size'] ?? json['size'] ?? 0;
    final typeStr =
        (json['file_type'] ?? json['type'] ?? '').toString().toLowerCase();

    return AnnounAttachment(
      fileId: json['file_id'] as int?,
      name: name,
      url: url,
      sizeMB: _toMB(rawSize),
      fileType: _fileTypeFromString(typeStr),
    );
  }

  static double _toMB(dynamic raw) {
    if (raw is double) return raw < 1000 ? raw : raw / (1024 * 1024);
    if (raw is int) return raw < 1000 ? raw.toDouble() : raw / (1024 * 1024);
    return 0.0;
  }

  static AttachmentFileType _fileTypeFromString(String type) {
    if (type == 'pdf') return AttachmentFileType.pdf;
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'image'].contains(type)) {
      return AttachmentFileType.image;
    }
    if (['doc', 'docx', 'word', 'ppt', 'pptx', 'xls', 'xlsx'].contains(type)) {
      return AttachmentFileType.doc;
    }
    return AttachmentFileType.other;
  }
}

// ---------- Announcement ----------

class Announcement {
  final String id;
  final String title;
  final String body;
  final String doctorName;
  final String subjectName;
  final String subjectCode;
  final AnnouncementType type;
  final AnnouncementTarget target;
  final AnnouncementPriority priority;
  final DateTime createdAt;
  final bool isRead;
  final List<AnnounAttachment> attachments;
  final bool isFromAdmin;

  // Extended API fields
  final int authorId;
  final String? targetCourseId;
  final String? targetDepartment;
  final int? targetYear;
  final int? targetStudentId;
  final List<int> targetUserIds;
  final DateTime? deadline;
  final int? assignmentId;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.doctorName,
    required this.subjectName,
    required this.subjectCode,
    required this.type,
    required this.target,
    required this.priority,
    required this.createdAt,
    this.isRead = false,
    this.attachments = const [],
    this.isFromAdmin = false,
    this.authorId = 0,
    this.targetCourseId,
    this.targetDepartment,
    this.targetYear,
    this.targetStudentId,
    this.targetUserIds = const [],
    this.deadline,
    this.assignmentId,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json['announcement_id'].toString(),
        title: json['title'] as String? ?? '',
        body: json['content'] as String? ?? '',
        doctorName: json['author_name'] as String? ?? '',
        subjectName: json['subject_name'] as String? ?? '',
        subjectCode: json['subject_code'] as String? ?? '',
        type: AnnouncementType.fromString(
            json['announcement_type'] as String? ?? 'normal'),
        target: AnnouncementTarget.fromString(
            json['target_type'] as String? ?? 'all'),
        priority: AnnouncementPriority.fromString(
            json['priority'] as String? ?? 'normal'),
        createdAt: DateTime.parse(json['created_at'] as String),
        isRead: json['is_read'] as bool? ?? false,
        attachments: (json['attachments'] as List<dynamic>?)
                ?.map((a) =>
                    AnnounAttachment.fromJson(a as Map<String, dynamic>))
                .toList() ??
            const [],
        authorId: json['author_id'] as int? ?? 0,
        targetCourseId: json['target_course_id'] as String?,
        targetDepartment: json['target_department'] as String?,
        targetYear: json['target_year'] as int?,
        targetStudentId: json['target_student_id'] as int?,
        targetUserIds: (json['target_user_ids'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            const [],
        deadline: json['deadline'] != null
            ? DateTime.tryParse(json['deadline'] as String)
            : null,
        assignmentId: json['assignment_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': body,
        'announcement_type': type.toApiString,
        'priority': priority.toApiString,
        'target_type': target.toApiString,
        if (targetCourseId != null) 'target_course_id': targetCourseId,
        if (targetDepartment != null) 'target_department': targetDepartment,
        if (targetYear != null) 'target_year': targetYear,
        if (targetStudentId != null) 'target_student_id': targetStudentId,
        if (targetUserIds.isNotEmpty) 'target_user_ids': targetUserIds,
      };

  Announcement copyWith({
    String? id,
    String? title,
    String? body,
    String? doctorName,
    String? subjectName,
    String? subjectCode,
    AnnouncementType? type,
    AnnouncementTarget? target,
    AnnouncementPriority? priority,
    DateTime? createdAt,
    bool? isRead,
    List<AnnounAttachment>? attachments,
    bool? isFromAdmin,
    int? authorId,
    String? targetCourseId,
    String? targetDepartment,
    int? targetYear,
    int? targetStudentId,
    List<int>? targetUserIds,
    DateTime? deadline,
    int? assignmentId,
  }) =>
      Announcement(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        doctorName: doctorName ?? this.doctorName,
        subjectName: subjectName ?? this.subjectName,
        subjectCode: subjectCode ?? this.subjectCode,
        type: type ?? this.type,
        target: target ?? this.target,
        priority: priority ?? this.priority,
        createdAt: createdAt ?? this.createdAt,
        isRead: isRead ?? this.isRead,
        attachments: attachments ?? this.attachments,
        isFromAdmin: isFromAdmin ?? this.isFromAdmin,
        authorId: authorId ?? this.authorId,
        targetCourseId: targetCourseId ?? this.targetCourseId,
        targetDepartment: targetDepartment ?? this.targetDepartment,
        targetYear: targetYear ?? this.targetYear,
        targetStudentId: targetStudentId ?? this.targetStudentId,
        targetUserIds: targetUserIds ?? this.targetUserIds,
        deadline: deadline ?? this.deadline,
        assignmentId: assignmentId ?? this.assignmentId,
      );

  // ---------- Display helpers ----------

  String get doctorInitials {
    final parts = doctorName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return doctorName.isNotEmpty ? doctorName[0].toUpperCase() : '?';
  }

  String get subjectInitials {
    final words = subjectName.trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return subjectName.isNotEmpty ? subjectName[0].toUpperCase() : '?';
  }

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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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
}
