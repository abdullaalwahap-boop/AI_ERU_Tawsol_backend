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
  /// Server files keep their real fileType icon even though [url] is set.
  final bool isServerFile;

  const AddAnnounAttachmentItem({
    required this.id,
    required this.name,
    required this.sizeLabel,
    required this.fileType,
    this.filePath,
    this.url,
    this.isServerFile = false,
  });

  /// A user-added external link (not a file).
  bool get isLink => url != null && !isServerFile;
  bool get isImage => fileType == AttachmentFileType.image && filePath != null;

  @override
  List<Object?> get props =>
      [id, name, sizeLabel, fileType, filePath, url, isServerFile];
}
