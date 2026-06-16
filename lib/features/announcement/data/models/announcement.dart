import 'package:ai_eru_tawasol/features/announcement/data/models/announ_attachment.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_enums.dart';

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

  final int authorId;
  final String? targetCourseId;
  final String? targetDepartment;
  final int? targetYear;
  final int? targetStudentId;
  final List<int> targetUserIds;
  final String? targetRole;
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
    this.targetRole,
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
        isFromAdmin: json['is_from_admin'] as bool? ?? false,
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
        targetRole: json['target_role'] as String?,
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
    String? targetRole,
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
        targetRole: targetRole ?? this.targetRole,
        deadline: deadline ?? this.deadline,
        assignmentId: assignmentId ?? this.assignmentId,
      );

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
