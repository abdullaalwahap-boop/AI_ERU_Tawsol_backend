import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_tab.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

export 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_tab.dart';

part 'announ_state.dart';

class AnnounCubit extends Cubit<AnnounState> {
  AnnounCubit(this._repo) : super(AnnounInitial());

  final AnnounRepo _repo;
  int _doctorUserId = 0;

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadForStudent() async {
    emit(AnnounLoading());
    try {
      final all = await _repo.getAllAnnouncements();
      if (isClosed) return;
      emit(AnnounLoaded(primary: all));
    } catch (e) {
      if (isClosed) return;
      emit(AnnounError(e.toString()));
    }
  }

  Future<void> loadForDoctor() async {
    emit(AnnounLoading());
    try {
      final results = await Future.wait([
        _repo.getMyAnnouncements(),
        _repo.getAllAnnouncements(),
      ]);
      if (isClosed) return;
      final adminOnly = _doctorUserId == 0
          ? results[1]
          : results[1].where((a) => a.authorId != _doctorUserId).toList();
      emit(AnnounLoaded(
        primary: results[0],
        secondary: adminOnly,
        activeTab: AnnounTab.mine,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(AnnounError(e.toString()));
    }
  }

  Future<void> loadForAdmin() async {
    emit(AnnounLoading());
    try {
      final sent = await _repo.getAdminAnnouncements();
      if (isClosed) return;
      emit(AnnounLoaded(primary: sent));
    } catch (e) {
      if (isClosed) return;
      emit(AnnounError(e.toString()));
    }
  }

  Future<void> loadForRole(AnnounRole role, {int userId = 0}) async {
    if (userId != 0) _doctorUserId = userId;
    switch (role) {
      case AnnounRole.student:
        return loadForStudent();
      case AnnounRole.doctor:
        return loadForDoctor();
      case AnnounRole.admin:
        return loadForAdmin();
    }
  }

  Future<void> refresh(AnnounRole role) => loadForRole(role);

  /// Re-fetches data in the background without emitting AnnounLoading,
  /// so the list updates silently (used by the WebSocket listener).
  Future<void> silentRefresh(AnnounRole role) async {
    final current = state;
    if (current is! AnnounLoaded) return;
    try {
      switch (role) {
        case AnnounRole.student:
          final all = await _repo.getAllAnnouncements();
          if (isClosed) return;
          emit((state as AnnounLoaded? ?? current).copyWith(primary: all));
        case AnnounRole.doctor:
          final results = await Future.wait([
            _repo.getMyAnnouncements(),
            _repo.getAllAnnouncements(),
          ]);
          if (isClosed) return;
          final adminOnly = _doctorUserId == 0
              ? results[1]
              : results[1].where((a) => a.authorId != _doctorUserId).toList();
          emit((state as AnnounLoaded? ?? current)
              .copyWith(primary: results[0], secondary: adminOnly));
        case AnnounRole.admin:
          final sent = await _repo.getAdminAnnouncements();
          if (isClosed) return;
          emit((state as AnnounLoaded? ?? current).copyWith(primary: sent));
      }
    } catch (_) {
      // silently ignore — user still sees previous data
    }
  }

  // ── Tabs & filters ────────────────────────────────────────────────────────

  void switchTab(AnnounTab tab) {
    final current = state;
    if (current is! AnnounLoaded) return;
    emit(current.copyWith(
        activeTab: tab, activeFilter: null, clearFilter: true));
  }

  void filterByType(AnnouncementType? type) {
    final current = state;
    if (current is! AnnounLoaded) return;
    emit(current.copyWith(
      activeFilter: type,
      clearFilter: type == null,
    ));
  }

  void filterByPriority(AnnouncementPriority? priority) {
    final current = state;
    if (current is! AnnounLoaded) return;
    emit(current.copyWith(
      priorityFilter: priority,
      clearPriorityFilter: priority == null,
    ));
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> markAsRead(int id) async {
    try {
      await _repo.markRead(id);
      final current = state;
      if (current is! AnnounLoaded) return;
      final updated = current.primary
          .map((a) => a.id == id.toString() ? a.copyWith(isRead: true) : a)
          .toList();
      emit(current.copyWith(primary: updated));
    } catch (_) {
      // silently ignore mark-read failures
    }
  }

  Future<bool> deleteAnnouncement(int id) async {
    final current = state;
    if (current is! AnnounLoaded) return false;
    try {
      await _repo.deleteAnnouncement(id);
      final updatedPrimary =
          current.primary.where((a) => a.id != id.toString()).toList();
      final updatedSecondary =
          current.secondary.where((a) => a.id != id.toString()).toList();
      emit(current.copyWith(
          primary: updatedPrimary, secondary: updatedSecondary));
      return true;
    } catch (e) {
      emit(AnnounError(e.toString()));
      return false;
    }
  }

  void replaceAnnouncement(Announcement updated) {
    final current = state;
    if (current is! AnnounLoaded) return;
    final updatedPrimary = current.primary
        .map((a) => a.id == updated.id ? updated : a)
        .toList();
    emit(current.copyWith(primary: updatedPrimary));
  }

  void localDelete(String id) {
    final current = state;
    if (current is! AnnounLoaded) return;
    emit(current.copyWith(
      primary: current.primary.where((a) => a.id != id).toList(),
      secondary: current.secondary.where((a) => a.id != id).toList(),
    ));
  }

  void localMarkRead(String id) {
    final current = state;
    if (current is! AnnounLoaded) return;
    emit(current.copyWith(
      primary: current.primary
          .map((a) => a.id == id ? a.copyWith(isRead: true) : a)
          .toList(),
      secondary: current.secondary
          .map((a) => a.id == id ? a.copyWith(isRead: true) : a)
          .toList(),
    ));
  }

  void prependAnnouncement(Announcement ann) {
    final current = state;
    if (current is! AnnounLoaded) return;
    emit(current.copyWith(primary: [ann, ...current.primary]));
  }
}
