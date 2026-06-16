import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/course/data/models/content_attachment.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_enums.dart';

class CourseContent {
  final String id;
  final String title;
  final String body;
  final ContentType type;
  final DateTime createdAt;
  final List<ContentAttachment> attachments;
  final bool isFromAdmin;
  final String authorName;
  final DateTime? deadline;
  final Announcement? announcement;
  final int? fileIdInt;
  final String? authorTypeCode;

  const CourseContent({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.attachments = const [],
    this.isFromAdmin = false,
    required this.authorName,
    this.deadline,
    this.announcement,
    this.fileIdInt,
    this.authorTypeCode,
  });

  bool get isQuizEligible =>
      type == ContentType.material &&
      fileIdInt != null &&
      (authorTypeCode == 'DR' || authorTypeCode == 'TA') &&
      attachments.isNotEmpty &&
      (attachments.first.fileType == ContentFileType.pdf ||
          attachments.first.fileType == ContentFileType.doc);

  CourseContent withAnnouncement(Announcement ann) {
    final updatedAttachments = ann.attachments
        .map((a) => ContentAttachment(
              name: a.name,
              sizeLabel: '${a.sizeMB.toStringAsFixed(1)} MB',
              fileType: _contentFileTypeFrom(a.fileType),
              url: a.url.isNotEmpty ? a.url : null,
              isImage: a.fileType == AttachmentFileType.image,
              fileId: a.fileId,
            ))
        .toList();

    final quizFileId = fileIdInt ??
        (type == ContentType.material && updatedAttachments.isNotEmpty
            ? updatedAttachments.first.fileId
            : null);

    return CourseContent(
      id: id,
      title: ann.title,
      body: ann.body,
      type: type,
      createdAt: createdAt,
      attachments: updatedAttachments,
      isFromAdmin: ann.isFromAdmin,
      authorName: ann.doctorName,
      deadline: ann.deadline,
      announcement: ann,
      fileIdInt: quizFileId,
      authorTypeCode: authorTypeCode,
    );
  }

  static ContentFileType _contentFileTypeFrom(AttachmentFileType t) {
    switch (t) {
      case AttachmentFileType.pdf:
        return ContentFileType.pdf;
      case AttachmentFileType.image:
        return ContentFileType.image;
      case AttachmentFileType.doc:
        return ContentFileType.doc;
      case AttachmentFileType.other:
        return ContentFileType.other;
    }
  }

  factory CourseContent.fromAnnouncement(Map<String, dynamic> json) {
    final ann = Announcement.fromJson(json);
    final contentType = switch (ann.type) {
      AnnouncementType.materialFile => ContentType.material,
      AnnouncementType.assignment => ContentType.assignment,
      _ => ContentType.announcement,
    };
    final attachments = ann.attachments
        .map((a) => ContentAttachment(
              name: a.name,
              sizeLabel: '${a.sizeMB.toStringAsFixed(1)} MB',
              fileType: _contentFileTypeFrom(a.fileType),
              url: a.url.isNotEmpty ? a.url : null,
              isImage: a.fileType == AttachmentFileType.image,
              fileId: a.fileId,
            ))
        .toList();

    final quizFileId = contentType == ContentType.material &&
            attachments.isNotEmpty
        ? attachments.first.fileId
        : null;

    return CourseContent(
      id: ann.id,
      title: ann.title,
      body: ann.body,
      type: contentType,
      createdAt: ann.createdAt,
      authorName: ann.doctorName,
      attachments: attachments,
      isFromAdmin: ann.isFromAdmin,
      deadline: ann.deadline,
      announcement: ann,
      fileIdInt: quizFileId,
      authorTypeCode: ann.isFromAdmin ? 'ADM' : 'DR',
    );
  }

  factory CourseContent.fromAssignment(Map<String, dynamic> json) {
    final title = json['title'] as String;

    final rawAttachments = json['attachments'] as List<dynamic>?;
    final List<ContentAttachment> attachments;

    if (rawAttachments != null && rawAttachments.isNotEmpty) {
      attachments = rawAttachments
          .map((a) => _attachmentFromFileJson(a as Map<String, dynamic>))
          .toList();
    } else {
      final fileType = json['file_type'] as String?;
      final filePath = json['file_path'] as String?;
      final linkUrl = json['link_url'] as String?;
      if (filePath != null) {
        final resolvedUrl = filePath.startsWith('http')
            ? filePath
            : '${ApiConstants.baseUrl}/$filePath';
        attachments = [
          ContentAttachment(
            name: title,
            sizeLabel: (fileType ?? 'file').toUpperCase(),
            fileType: ContentFileType.fromString(fileType),
            url: resolvedUrl,
            isImage:
                ContentFileType.fromString(fileType) == ContentFileType.image,
          ),
        ];
      } else if (linkUrl != null) {
        attachments = [
          ContentAttachment(
            name: 'Open Link',
            sizeLabel: 'URL',
            fileType: ContentFileType.other,
            url: linkUrl,
          ),
        ];
      } else {
        attachments = const [];
      }
    }

    return CourseContent(
      id: (json['assignment_id'] as int).toString(),
      title: title,
      body: _assignmentBody(json),
      type: ContentType.assignment,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorName: json['author_name'] as String? ?? '',
      attachments: attachments,
      isFromAdmin: false,
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'] as String)
          : null,
    );
  }

  factory CourseContent.fromFile(Map<String, dynamic> json) {
    final fileId = json['file_id'] as int;
    return CourseContent(
      id: fileId.toString(),
      title: json['title'] as String,
      body: json['description'] as String? ??
          json['text_content'] as String? ??
          '',
      type: ContentType.material,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorName: '',
      attachments: [_attachmentFromFileJson(json)],
      isFromAdmin: false,
      fileIdInt: fileId,
      authorTypeCode: json['author_type_code'] as String?,
    );
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
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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

  static ContentAttachment _attachmentFromFileJson(Map<String, dynamic> j) {
    final fileType = (j['file_type'] as String? ?? 'other').toLowerCase();
    final title = j['title'] as String? ?? j['file_name'] as String? ?? 'File';
    final filePath = j['file_path'] as String?;
    final linkUrl = j['link_url'] as String?;
    final rawSize = j['file_size'] ?? 0;
    final sizeMB = rawSize is int
        ? (rawSize < 1000 ? rawSize.toDouble() : rawSize / (1024 * 1024))
        : (rawSize is double
            ? (rawSize < 1000 ? rawSize : rawSize / (1024 * 1024))
            : 0.0);

    String? url;
    if (linkUrl != null && linkUrl.isNotEmpty) {
      url = linkUrl;
    } else if (filePath != null && filePath.isNotEmpty) {
      url = filePath.startsWith('http')
          ? filePath
          : '${ApiConstants.baseUrl}/$filePath';
    }

    final ct = ContentFileType.fromString(fileType);
    return ContentAttachment(
      name: title,
      sizeLabel: url == linkUrl && linkUrl != null
          ? 'URL'
          : '${sizeMB.toStringAsFixed(1)} MB',
      fileType: ct,
      url: url,
      isImage: ct == ContentFileType.image,
    );
  }

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
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        parts.add('Deadline: ${months[dl.month - 1]} ${dl.day}, ${dl.year}');
      }
    }

    return parts.join('\n\n');
  }
}
