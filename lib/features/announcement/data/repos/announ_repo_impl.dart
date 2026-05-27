import 'package:ai_eru_tawasol/features/announcement/data/datasources/announ_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';

class AnnounRepoImpl implements AnnounRepo {
  const AnnounRepoImpl(this._ds);
  final AnnounRemoteDatasource _ds;

  @override
  Future<List<Announcement>> getAllAnnouncements({
    String? announcementType,
    String? priority,
    bool unreadOnly = false,
    String? search,
    int skip = 0,
    int limit = 50,
  }) =>
      _ds.getAnnouncements(
        announcementType: announcementType,
        priority: priority,
        unreadOnly: unreadOnly,
        search: search,
        skip: skip,
        limit: limit,
      );

  @override
  Future<List<Announcement>> getMyAnnouncements({
    int skip = 0,
    int limit = 50,
  }) =>
      _ds.getSentAnnouncements(skip: skip, limit: limit);

  @override
  Future<List<Announcement>> getAdminAnnouncements({
    int skip = 0,
    int limit = 50,
  }) =>
      _ds.getSentAnnouncements(skip: skip, limit: limit);

  @override
  Future<int> getUnreadCount() => _ds.getUnreadCount();

  @override
  Future<Announcement> getAnnouncementDetail(int id) =>
      _ds.getAnnouncementDetail(id);

  @override
  Future<List<RecipientUser>> getRecipients({
    String? role,
    String? courseId,
    String? department,
    String? search,
    int skip = 0,
    int limit = 100,
  }) =>
      _ds.getRecipients(
        role: role,
        courseId: courseId,
        department: department,
        search: search,
        skip: skip,
        limit: limit,
      );

  @override
  Future<Announcement> createAnnouncement(Map<String, dynamic> payload) =>
      _ds.createAnnouncement(payload);

  @override
  Future<Announcement> updateAnnouncement(int id, Map<String, dynamic> payload) =>
      _ds.updateAnnouncement(id, payload);

  @override
  Future<void> deleteAnnouncement(int id) => _ds.deleteAnnouncement(id);

  @override
  Future<void> markRead(int id) => _ds.markRead(id);

  @override
  Future<void> cloneFilesToAnnouncement({
    required int fromAnnouncementId,
    required int toAnnouncementId,
  }) =>
      _ds.cloneFilesToAnnouncement(
        fromAnnouncementId: fromAnnouncementId,
        toAnnouncementId: toAnnouncementId,
      );

  @override
  Future<void> uploadAnnouncementFile({
    required int announcementId,
    required String materialId,
    required String title,
    required String fileType,
    String? filePath,
    String? linkUrl,
  }) =>
      _ds.uploadAnnouncementFile(
        announcementId: announcementId,
        materialId: materialId,
        title: title,
        fileType: fileType,
        filePath: filePath,
        linkUrl: linkUrl,
      );

  @override
  Future<void> deleteFile(int fileId) => _ds.deleteFile(fileId);

  @override
  Future<void> notifyAnnouncement(int id) => _ds.notifyAnnouncement(id);
}
