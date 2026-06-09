class Assignment {
  final int id;
  final String materialId;
  final int authorId;
  final int? announcementId;
  final String title;
  final String? description;
  final DateTime deadline;
  final String? fileType;
  final String? filePath;
  final String? linkUrl;
  final String? textContent;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Assignment({
    required this.id,
    required this.materialId,
    required this.authorId,
    this.announcementId,
    required this.title,
    this.description,
    required this.deadline,
    this.fileType,
    this.filePath,
    this.linkUrl,
    this.textContent,
    required this.createdAt,
    this.updatedAt,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        id: json['assignment_id'] as int,
        materialId: json['material_id'] as String,
        authorId: json['author_id'] as int,
        announcementId: json['announcement_id'] as int?,
        title: json['title'] as String,
        description: json['description'] as String?,
        deadline: DateTime.parse(json['deadline'] as String),
        fileType: json['file_type'] as String?,
        filePath: json['file_path'] as String?,
        linkUrl: json['link_url'] as String?,
        textContent: json['text_content'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  // ---------- Display helpers ----------

  bool get isOverdue => deadline.isBefore(DateTime.now());

  String get deadlineFormatted {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = deadline.hour;
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final minute = deadline.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    return '${months[deadline.month - 1]} ${deadline.day}, ${deadline.year}  $hour:$minute $period';
  }

  String get timeUntilDeadline {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return 'Overdue';
    if (diff.inDays > 7) return '${diff.inDays} days left';
    if (diff.inDays > 0) return '${diff.inDays}d ${diff.inHours % 24}h left';
    if (diff.inHours > 0) return '${diff.inHours}h left';
    return '${diff.inMinutes}m left';
  }

  Assignment copyWith({
    int? id,
    String? materialId,
    int? authorId,
    String? title,
    String? description,
    DateTime? deadline,
    String? fileType,
    String? filePath,
    String? linkUrl,
    String? textContent,
  }) =>
      Assignment(
        id: id ?? this.id,
        materialId: materialId ?? this.materialId,
        authorId: authorId ?? this.authorId,
        announcementId: announcementId,
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        fileType: fileType ?? this.fileType,
        filePath: filePath ?? this.filePath,
        linkUrl: linkUrl ?? this.linkUrl,
        textContent: textContent ?? this.textContent,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
