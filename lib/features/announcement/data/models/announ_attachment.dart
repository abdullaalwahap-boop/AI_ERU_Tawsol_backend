import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_enums.dart';

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
    final name = (json['file_name'] as String?) ??
        (json['name'] as String?) ??
        (json['title'] as String?) ??
        '';

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
          : '${ApiConstants.baseUrl}/$filePath';
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
