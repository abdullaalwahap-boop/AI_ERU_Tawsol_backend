import 'package:ai_eru_tawasol/features/announcement/data/models/announcement.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_enums.dart';

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
