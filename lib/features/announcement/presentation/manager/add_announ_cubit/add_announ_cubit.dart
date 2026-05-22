import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';

export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_announ_state.dart';

// ── Mock data (replace with real API data) ────────────────────────────────────

const _doctorSubjects = [
  'Data Structures · CS301',
  'Algorithms · CS302',
  'Operating Systems · CS303',
  'Advanced Algorithms · CS401',
];

const _adminDepartments = [
  'Computer Science',
  'Electrical Engineering',
  'Business Administration',
  'Architecture',
  'Medicine',
  'Pharmacy',
];

const _adminLevels = ['Level 1', 'Level 2', 'Level 3', 'Level 4'];

// ── Cubit ─────────────────────────────────────────────────────────────────────

class AddAnnounCubit extends Cubit<AddAnnounState> {
  AddAnnounCubit(AnnounRole role) : super(AddAnnounState.initial(role));

  // ── Doctor ────────────────────────────────────────────────────────────────

  void selectPostType(AnnouncementType type) => emit(state.copyWith(
        postType: type,
        attachments: type == AnnouncementType.normal ? [] : null,
      ));

  void addAttachment(AddAnnounAttachmentItem item) {
    final updated = List<AddAnnounAttachmentItem>.from(state.attachments)
      ..add(item);
    emit(state.copyWith(attachments: updated));
  }

  void removeAttachment(String id) {
    emit(state.copyWith(
      attachments: state.attachments.where((a) => a.id != id).toList(),
    ));
  }

  void setTitle(String v) => emit(state.copyWith(title: v));

  void setDetails(String v) => emit(state.copyWith(details: v));

  void setPriority(AnnouncementPriority priority) =>
      emit(state.copyWith(priority: priority));

  void toggleOption(String option) {
    final updated = Set<String>.from(state.selectedOptions);
    if (updated.contains(option)) {
      updated.remove(option);
    } else {
      updated.add(option);
    }
    emit(state.copyWith(selectedOptions: updated));
  }

  List<String> get audienceOptions => _doctorSubjects;

  // ── Admin ─────────────────────────────────────────────────────────────────

  void setAdminUserType(AdminUserType type) => emit(state.copyWith(
        adminUserType: type,
        selectedDepartments: <String>{},
        selectedLevels: <String>{},
      ));

  void toggleDepartment(String dept) {
    final updated = Set<String>.from(state.selectedDepartments);
    if (updated.contains(dept)) {
      updated.remove(dept);
    } else {
      updated.add(dept);
    }
    emit(state.copyWith(selectedDepartments: updated));
  }

  void toggleLevel(String level) {
    final updated = Set<String>.from(state.selectedLevels);
    if (updated.contains(level)) {
      updated.remove(level);
    } else {
      updated.add(level);
    }
    emit(state.copyWith(selectedLevels: updated));
  }

  List<String> get adminDepartments => _adminDepartments;
  List<String> get adminLevels => _adminLevels;

  // ── Shared ────────────────────────────────────────────────────────────────

  Future<void> post() async {
    if (!state.canPost) return;
    emit(state.copyWith(isPosting: true, error: null));
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      emit(state.copyWith(isPosting: false, isPosted: true));
    } catch (e) {
      emit(state.copyWith(isPosting: false, error: e.toString()));
    }
  }
}
