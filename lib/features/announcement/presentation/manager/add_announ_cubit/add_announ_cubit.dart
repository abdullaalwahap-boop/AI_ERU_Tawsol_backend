import 'package:ai_eru_tawasol/features/announcement/data/datasources/assignment_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/assignment_model.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';

part 'add_announ_state.dart';

// Available departments (matches Material.department_course values in backend)
const kDepartments = [
  'Artificial Intelligence',
  'Software Engineering',
  'Data Science',
  'Cybersecurity',
  'General',
];

// Year options per department type
const kSpecializedYears = [3, 4]; // AI, DS, CB, SE
const kGeneralYears = [1, 2];

class AddAnnounCubit extends Cubit<AddAnnounState> {
  AddAnnounCubit({
    required AnnounRole role,
    required AnnounRepo repo,
    required AssignmentRemoteDatasource assignmentDs,
    required CourseRepo courseRepo,
    Announcement? announcementToEdit,
  })  : _repo = repo,
        _assignmentDs = assignmentDs,
        _courseRepo = courseRepo,
        _announcementToEdit = announcementToEdit,
        super(_buildInitial(role, announcementToEdit));

  final AnnounRepo _repo;
  final AssignmentRemoteDatasource _assignmentDs;
  final CourseRepo _courseRepo;
  final Announcement? _announcementToEdit;

  bool get isEditMode => _announcementToEdit != null;

  static AddAnnounState _buildInitial(
      AnnounRole role, Announcement? toEdit) {
    if (toEdit == null) return AddAnnounState.initial(role);
    final preSelectedOptions = toEdit.targetCourseId != null
        ? {toEdit.targetCourseId!}
        : const <String>{};
    final preAttachments = toEdit.attachments
        .map((a) => AddAnnounAttachmentItem(
              id: a.url,
              name: a.name,
              sizeLabel: '${a.sizeMB.toStringAsFixed(1)} MB',
              fileType: a.fileType,
              url: a.url,
              isServerFile: true,
            ))
        .toList();
    return AddAnnounState(
      role: role,
      postType: toEdit.type,
      title: toEdit.title,
      details: toEdit.body,
      priority: toEdit.priority,
      selectedOptions: preSelectedOptions,
      selectedCourseId: toEdit.targetCourseId,
      selectedDepartments: toEdit.targetDepartment != null
          ? {toEdit.targetDepartment!}
          : const {},
      selectedLevels: const {},
      targetYear: toEdit.targetYear,
      attachments: preAttachments,
    );
  }

  // ── Init ──────────────────────────────────────────────────────────────────

  /// Load courses for doctor/TA from the CourseRepo or materials API.
  /// Call this in initState / view creation for doctor/TA role.
  Future<void> initCourses(List<CourseOption> courses) async {
    if (state.role == AnnounRole.admin) return;
    emit(state.copyWith(isLoadingCourses: true, courses: courses));
    // Auto-select if only one course
    if (courses.length == 1) {
      emit(state.copyWith(
        isLoadingCourses: false,
        selectedCourseId: courses.first.id,
        selectedOptions: {courses.first.id},
      ));
    } else {
      emit(state.copyWith(isLoadingCourses: false));
    }
  }

  /// Fetches the doctor's assigned courses from the backend and populates
  /// the course selector. Auto-selects when only one course is available.
  Future<void> loadDoctorCourses() async {
    if (state.role == AnnounRole.admin) return;
    emit(state.copyWith(isLoadingCourses: true));
    try {
      final courses = await _courseRepo.getDoctorCourses();
      if (isClosed) return;
      final options =
          courses.map((c) => CourseOption(id: c.id, name: c.name)).toList();
      final alreadySelected = state.selectedCourseId != null;
      if (options.length == 1 && !alreadySelected) {
        emit(state.copyWith(
          isLoadingCourses: false,
          courses: options,
          selectedCourseId: options.first.id,
          selectedOptions: {options.first.id},
        ));
      } else {
        emit(state.copyWith(isLoadingCourses: false, courses: options));
      }
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(isLoadingCourses: false));
    }
  }

  // ── Doctor ────────────────────────────────────────────────────────────────

  void selectPostType(AnnouncementType type) => emit(state.copyWith(
        postType: type,
        attachments: type == AnnouncementType.normal ? [] : null,
        clearDeadline: type != AnnouncementType.assignment,
      ));

  void selectCourse(String courseId) => emit(state.copyWith(
        selectedCourseId: courseId,
        selectedOptions: {courseId},
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

  void setDeadline(DateTime dt) => emit(state.copyWith(deadline: dt));

  // Kept for backward compat with existing audience chip widget
  void toggleOption(String option) {
    final updated = Set<String>.from(state.selectedOptions);
    if (updated.contains(option)) {
      updated.remove(option);
    } else {
      updated.add(option);
    }
    final newCourseId = updated.length == 1 ? updated.first : null;
    emit(state.copyWith(
      selectedOptions: updated,
      selectedCourseId: newCourseId,
      clearCourse: newCourseId == null,
    ));
  }

  List<String> get audienceOptions =>
      state.courses.map((c) => c.id).toList();

  List<CourseOption> get courseList => state.courses;

  // ── Admin ─────────────────────────────────────────────────────────────────

  void setAdminUserType(AdminUserType type) => emit(state.copyWith(
        adminUserType: type,
        selectedDepartments: <String>{},
        selectedLevels: <String>{},
        clearYear: true,
        selectedRecipientIds: {},
        recipients: [],
      ));

  void toggleDepartment(String dept) {
    final updated = Set<String>.from(state.selectedDepartments);
    if (updated.contains(dept)) {
      updated.remove(dept);
    } else {
      updated.add(dept);
    }
    emit(state.copyWith(selectedDepartments: updated, clearYear: true));
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

  void setTargetYear(int? year) =>
      emit(state.copyWith(targetYear: year, clearYear: year == null));

  List<String> get adminDepartments => kDepartments;

  List<int> get availableYears {
    final depts = state.selectedDepartments;
    if (depts.isEmpty) return [...kGeneralYears, ...kSpecializedYears];
    if (depts.contains('General')) return kGeneralYears;
    return kSpecializedYears;
  }

  // ── Recipient search ──────────────────────────────────────────────────────

  Future<void> searchRecipients(String query) async {
    emit(state.copyWith(isLoadingRecipients: true));
    try {
      final role = state.adminUserType?.roleFilter;
      final dept = state.selectedDepartments.isNotEmpty
          ? state.selectedDepartments.first
          : null;
      final results = await _repo.getRecipients(
        role: role,
        department: dept,
        search: query.isNotEmpty ? query : null,
      );
      emit(state.copyWith(recipients: results, isLoadingRecipients: false));
    } catch (_) {
      emit(state.copyWith(isLoadingRecipients: false));
    }
  }

  void toggleRecipient(int userId) {
    final updated = Set<int>.from(state.selectedRecipientIds);
    if (updated.contains(userId)) {
      updated.remove(userId);
    } else {
      updated.add(userId);
    }
    emit(state.copyWith(selectedRecipientIds: updated));
  }

  // ── Post ──────────────────────────────────────────────────────────────────

  Future<void> post() async {
    if (!state.canPost) return;
    emit(state.copyWith(isPosting: true, clearError: true));
    try {
      if (state.postType == AnnouncementType.assignment) {
        await _postAssignment();
        emit(state.copyWith(isPosting: false, isPosted: true));
      } else {
        final ann = await _postAnnouncement();
        emit(state.copyWith(
            isPosting: false, isPosted: true, postedAnnouncement: ann));
      }
    } catch (e) {
      emit(state.copyWith(isPosting: false, error: e.toString()));
    }
  }

  Future<Assignment> _postAssignment() {
    final courseId = state.selectedCourseId ?? state.selectedOptions.first;
    return _assignmentDs.createAssignment(
      materialId: courseId,
      title: state.title,
      description: state.details.isNotEmpty ? state.details : null,
      deadline: state.deadline ?? DateTime.now().add(const Duration(days: 7)),
    );
  }

  Future<Announcement> _postAnnouncement() {
    final payload = _buildAnnouncementPayload();
    if (isEditMode) {
      final id = int.parse(_announcementToEdit!.id);
      return _repo.updateAnnouncement(id, payload);
    }
    return _repo.createAnnouncement(payload);
  }

  Map<String, dynamic> _buildAnnouncementPayload() {
    final s = state;
    final payload = <String, dynamic>{
      'title': s.title,
      'content': s.details,
      'announcement_type': s.postType.toApiString,
      'priority': s.priority.toApiString,
    };

    if (s.role == AnnounRole.admin) {
      _applyAdminTarget(payload);
    } else {
      _applyDoctorTarget(payload);
    }

    return payload;
  }

  void _applyAdminTarget(Map<String, dynamic> p) {
    final ut = state.adminUserType;
    if (ut == null) return;

    switch (ut) {
      case AdminUserType.all:
        p['target_type'] = 'all';
      case AdminUserType.students:
        if (state.selectedDepartments.contains('General')) {
          p['target_type'] = 'level';
          p['target_year'] = state.targetYear;
        } else if (state.selectedDepartments.length == 1) {
          p['target_type'] = 'level';
          p['target_department'] = state.selectedDepartments.first;
          p['target_year'] = state.targetYear;
        } else {
          p['target_type'] = 'level';
          p['target_year'] = state.targetYear;
        }
      case AdminUserType.doctors:
      case AdminUserType.ta:
        if (state.selectedDepartments.length == 1) {
          p['target_type'] = 'department';
          p['target_department'] = state.selectedDepartments.first;
        } else {
          p['target_type'] = 'all';
        }
      case AdminUserType.specificUsers:
        p['target_type'] = 'users';
        p['target_user_ids'] = state.selectedRecipientIds.toList();
    }
  }

  void _applyDoctorTarget(Map<String, dynamic> p) {
    final courseId = state.selectedCourseId ?? state.selectedOptions.firstOrNull;
    if (courseId == null) return;
    p['target_type'] = 'course';
    p['target_course_id'] = courseId;
  }
}
