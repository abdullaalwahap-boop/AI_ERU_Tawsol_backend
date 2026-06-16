import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart' hide PickedFile;
import 'package:ai_eru_tawasol/features/chat/data/services/picked_file.dart';

export 'picked_file.dart';

class AttachmentService {
  AttachmentService._();

  static final AttachmentService instance = AttachmentService._();

  final _picker = ImagePicker();

  Future<PickedFile?> pickFromCamera() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (xfile == null) return null;
    return PickedFile(path: xfile.path, name: xfile.name, type: 'image');
  }

  Future<PickedFile?> pickFromGallery() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (xfile == null) return null;
    final isVideo = xfile.name.toLowerCase().endsWith('.mp4') ||
        xfile.name.toLowerCase().endsWith('.mov') ||
        xfile.name.toLowerCase().endsWith('.avi');
    return PickedFile(
      path: xfile.path,
      name: xfile.name,
      type: isVideo ? 'video' : 'image',
    );
  }

  Future<PickedFile?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'csv',
        'zip', 'rar',
      ],
    );
    final file = result?.files.firstOrNull;
    if (file == null || file.path == null) return null;
    return PickedFile(path: file.path!, name: file.name, type: 'file');
  }

  Future<PickedFile?> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'm4a', 'ogg', 'wav', 'aac'],
    );
    final file = result?.files.firstOrNull;
    if (file == null || file.path == null) return null;
    return PickedFile(path: file.path!, name: file.name, type: 'audio');
  }
}
