import 'package:equatable/equatable.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';

class AddAnnounAttachmentItem extends Equatable {
  final String id;
  final String name;
  final String sizeLabel;
  final AttachmentFileType fileType;
  final String? filePath;
  final String? url;

  /// True when this item was loaded from the server (edit mode pre-fill).
  final bool isServerFile;

  /// Backend file_id — only set for server files, used for deletion on edit.
  final int? fileId;

  const AddAnnounAttachmentItem({
    required this.id,
    required this.name,
    required this.sizeLabel,
    required this.fileType,
    this.filePath,
    this.url,
    this.isServerFile = false,
    this.fileId,
  });

  bool get isLink => url != null && !isServerFile;
  bool get isImage => fileType == AttachmentFileType.image && filePath != null;

  @override
  List<Object?> get props =>
      [id, name, sizeLabel, fileType, filePath, url, isServerFile, fileId];
}
