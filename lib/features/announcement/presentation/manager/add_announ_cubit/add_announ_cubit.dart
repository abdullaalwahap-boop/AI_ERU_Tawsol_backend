import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_audience_type.dart';

export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_audience_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_announ_state.dart';

// ── Mock audience data (replace with real API data) ──────────────────────────

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

  void selectAudienceType(AddAnnounAudienceType type) =>
      emit(state.copyWith(audienceType: type, selectedOptions: {}));

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

  List<String> get audienceOptions {
    switch (state.audienceType) {
      case AddAnnounAudienceType.department:
        return _adminDepartments;
      case AddAnnounAudienceType.subject:
        return _doctorSubjects;
      case AddAnnounAudienceType.level:
        return _adminLevels;
      default:
        return [];
    }
  }

  Future<void> post() async {
    if (!state.canPost) return;
    emit(state.copyWith(isPosting: true, error: null));
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1200));
      emit(state.copyWith(isPosting: false, isPosted: true));
    } catch (e) {
      emit(state.copyWith(isPosting: false, error: e.toString()));
    }
  }
}
