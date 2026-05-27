import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';

abstract class AnnounRepo {
  // ── Read ──────────────────────────────────────────────────────────────────
  Future<List<Announcement>> getAllAnnouncements({
    String? announcementType,
    String? priority,
    bool unreadOnly = false,
    String? search,
    int skip = 0,
    int limit = 50,
  });

  Future<List<Announcement>> getMyAnnouncements({int skip = 0, int limit = 50});

  Future<List<Announcement>> getAdminAnnouncements({
    int skip = 0,
    int limit = 50,
  });

  Future<int> getUnreadCount();

  Future<Announcement> getAnnouncementDetail(int id);

  Future<List<RecipientUser>> getRecipients({
    String? role,
    String? courseId,
    String? department,
    String? search,
    int skip = 0,
    int limit = 100,
  });

  // ── Write ─────────────────────────────────────────────────────────────────
  Future<Announcement> createAnnouncement(Map<String, dynamic> payload);

  Future<Announcement> updateAnnouncement(int id, Map<String, dynamic> payload);

  Future<void> deleteAnnouncement(int id);

  Future<void> markRead(int id);

  Future<void> uploadAnnouncementFile({
    required int announcementId,
    String? materialId,
    required String title,
    required String fileType,
    String? filePath,
    String? linkUrl,
  });

  Future<void> deleteFile(int fileId);

  Future<void> notifyAnnouncement(int id);
}
