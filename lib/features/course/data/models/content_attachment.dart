import 'package:ai_eru_tawasol/features/course/data/models/course_enums.dart';

class ContentAttachment {
  final String name;
  final String sizeLabel;
  final ContentFileType fileType;
  final String? url;
  final bool isImage;
  final int? fileId;

  const ContentAttachment({
    required this.name,
    required this.sizeLabel,
    required this.fileType,
    this.url,
    this.isImage = false,
    this.fileId,
  });
}
