import 'package:ai_eru_tawasol/features/announcement/data/datasources/assignment_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/dr_audience_type.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_attachment_item.dart';
export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
export 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/dr_audience_type.dart';

part 'add_announ_state.dart';

// Available departments (matches Material.department_course values in backend)
const kDepartments = [
  'Artificial Intelligence',
  'Software Engineering',
  'Data Science',
  'Cybersecurity',
  'General',
];

// Year pools by department context
const kSpecializedYears = [3, 4]; // specific departments
const kGeneralYears = [1, 2]; // General department

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

  bool get isEditMode => state.isEditMode;

  static AddAnnounState _buildInitial(AnnounRole role, Announcement? toEdit) {
    if (toEdit == null) return AddAnnounState.initial(role);
    final preSelectedOptions = toEdit.targetCourseId != null
        ? {toEdit.targetCourseId!}
        : const <String>{};
    final preAttachments = toEdit.attachments
        .map((a) => AddAnnounAttachmentItem(
              id: a.fileId?.toString() ?? a.url,
              name: a.name,
              sizeLabel: '${a.sizeMB.toStringAsFixed(1)} MB',
              fileType: a.fileType,
              url: a.url,
              isServerFile: true,
              fileId: a.fileId,
            ))
        .toList();

    // Restore admin audience from the saved announcement fields
    AdminUserType? adminUserType;
    Set<String> selectedLevels = const {};
    Set<int> selectedRecipientIds = const {};
    if (role == AnnounRole.admin) {
      switch (toEdit.target) {
        case AnnouncementTarget.all:
          adminUserType = AdminUserType.all;
        case AnnouncementTarget.users:
          adminUserType = AdminUserType.specificUsers;
          selectedRecipientIds = toEdit.targetUserIds.toSet();
        case AnnouncementTarget.role:
          switch (toEdit.targetRole) {
            case 'DR':
              adminUserType = AdminUserType.doctors;
            case 'TA':
              adminUserType = AdminUserType.ta;
            case 'STU':
              adminUserType = AdminUserType.students;
            default:
              break;
          }
        case AnnouncementTarget.level:
          adminUserType = AdminUserType.students;
          if (toEdit.targetYear != null) {
            selectedLevels = {'Level ${toEdit.targetYear}'};
          }
        default:
          break;
      }
    }

    // Restore DR/TA audience type from the saved announcement
    DrAudienceType drAudienceType = DrAudienceType.course;
    if (role == AnnounRole.doctor) {
      if (toEdit.target == AnnouncementTarget.users) {
        drAudienceType = DrAudienceType.specificStudents;
        selectedRecipientIds = toEdit.targetUserIds.toSet();
      }
    }

    return AddAnnounState(
      role: role,
      postType: toEdit.type,
      title: toEdit.title,
      details: toEdit.body,
      priority: toEdit.priority,
      drAudienceType: drAudienceType,
      selectedOptions: preSelectedOptions,
      selectedCourseId: toEdit.targetCourseId,
      adminUserType: adminUserType,
      selectedDepartments: toEdit.targetDepartment != null
          ? {toEdit.targetDepartment!}
          : const {},
      selectedLevels: selectedLevels,
      selectedRecipientIds: selectedRecipientIds,
      targetYear: toEdit.targetYear,
      deadline: toEdit.deadline,
      isEditMode: true,
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
    if (state.role == AnnounRole.admin || state.role == AnnounRole.student) return;
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
    // Edit mode only: load recipients so selected chips can display names
    if (!isClosed &&
        state.isEditMode &&
        state.drAudienceType == DrAudienceType.specificStudents &&
        state.selectedRecipientIds.isNotEmpty &&
        state.recipients.isEmpty) {
      await searchRecipients('');
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

  List<String> get audienceOptions => state.courses.map((c) => c.id).toList();

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
    // Clear level whenever available levels may change
    emit(state.copyWith(
      selectedDepartments: updated,
      clearYear: true,
      selectedLevels: <String>{},
    ));
  }

  /// Multi-select: toggles a level in/out of the selected set.
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

  /// Available levels depend on which departments are selected.
  /// No dept selected → no levels (post to all students directly).
  /// General only → levels 1, 2.
  /// Specific dept(s) only → levels 3, 4.
  /// General + specific dept → levels 1, 2, 3, 4.
  List<int> get availableYears {
    final depts = state.selectedDepartments;
    if (depts.isEmpty) return [];
    final hasGeneral = depts.contains('General');
    final hasSpecific = depts.any((d) => d != 'General');
    if (hasGeneral && hasSpecific) {
      return [...kGeneralYears, ...kSpecializedYears];
    }
    if (hasGeneral) return kGeneralYears;
    return kSpecializedYears;
  }

  // ── DR/TA audience type ───────────────────────────────────────────────────

  void setDrAudienceType(DrAudienceType type) {
    emit(state.copyWith(
      drAudienceType: type,
      selectedRecipientIds: <int>{},
      recipients: [],
      // assignment not allowed for specific students — reset to normal
      postType: (type == DrAudienceType.specificStudents &&
              state.postType == AnnouncementType.assignment)
          ? AnnouncementType.normal
          : null,
      clearDeadline: type == DrAudienceType.specificStudents &&
          state.postType == AnnouncementType.assignment,
    ));
  }

  /// Toggle course filter for the specific-students search.
  /// Selecting the same course again clears the filter.
  /// Results are cleared — user must type to search.
  void toggleCourseFilter(String courseId) {
    final newId = state.selectedCourseId == courseId ? null : courseId;
    emit(state.copyWith(
      selectedCourseId: newId,
      clearCourse: newId == null,
      selectedOptions: newId != null ? {newId} : const <String>{},
      recipients: [],
    ));
  }

  // ── Recipient search ──────────────────────────────────────────────────────

  Future<void> searchRecipients(String query) async {
    emit(state.copyWith(isLoadingRecipients: true));
    try {
      final String? roleFilter;
      final String? courseFilter;
      if (state.role != AnnounRole.admin) {
        // DR/TA: always target students, optionally filtered by course
        roleFilter = 'STU';
        courseFilter = state.selectedCourseId;
      } else {
        roleFilter = state.adminUserType?.roleFilter;
        courseFilter = null;
      }
      final results = await _repo.getRecipients(
        role: roleFilter,
        courseId: courseFilter,
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
      if (isEditMode) {
        if (state.postType == AnnouncementType.assignment) {
          await _updateAssignmentRecord();
        }
        // Update the existing announcement (uses first selected course as target).
        final ann = await _postAnnouncement();

        // For any extra selected courses, create brand-new announcements.
        final primaryId =
            state.selectedCourseId ?? state.selectedOptions.firstOrNull;
        final extraIds =
            state.selectedOptions.where((id) => id != primaryId).toList();
        if (extraIds.isNotEmpty) {
          if (state.postType == AnnouncementType.assignment) {
            final fromAnnId = int.tryParse(_announcementToEdit?.id ?? '');
            await Future.wait(extraIds.map((id) => _createAssignment(
                courseId: id, cloneFromAnnouncementId: fromAnnId)));
          } else {
            await Future.wait(extraIds.map(
                (id) => _postAnnouncement(courseId: id, forceCreate: true)));
          }
        }

        emit(state.copyWith(
            isPosting: false, isPosted: true, postedAnnouncement: ann));
        return;
      }

      // Admin + students + multiple levels: one announcement per level.
      if (state.role == AnnounRole.admin &&
          state.adminUserType == AdminUserType.students &&
          state.selectedLevels.length > 1) {
        final years = state.selectedLevels
            .map((l) => int.tryParse(l.replaceAll('Level ', '')))
            .whereType<int>()
            .toList();
        final results = await Future.wait(
          years.map((y) => _postAnnouncement(overrideYear: y)),
        );
        final first = results.whereType<Announcement>().firstOrNull;
        emit(state.copyWith(
            isPosting: false, isPosted: true, postedAnnouncement: first));
        return;
      }

      // Create: for doctor/TA course mode, iterate over every selected course.
      // Admin or DR/TA specific-students mode → single call (no course iteration).
      final isSpecificStudents = state.role != AnnounRole.admin &&
          state.drAudienceType == DrAudienceType.specificStudents;
      final courseIds = (state.role != AnnounRole.admin && !isSpecificStudents)
          ? state.selectedOptions.toList()
          : <String?>[null];

      // For admin students with exactly one level selected, extract the year.
      final adminStudentYear = (state.role == AnnounRole.admin &&
              state.adminUserType == AdminUserType.students &&
              state.selectedLevels.length == 1)
          ? int.tryParse(state.selectedLevels.first.replaceAll('Level ', ''))
          : null;

      if (state.postType == AnnouncementType.assignment) {
        final results = await Future.wait(
          courseIds.map((id) => _createAssignment(courseId: id ?? '')),
        );
        final first = results.whereType<Announcement>().firstOrNull;
        emit(state.copyWith(
            isPosting: false, isPosted: true, postedAnnouncement: first));
      } else {
        final results = await Future.wait(
          courseIds.map((id) => _postAnnouncement(
                courseId: id,
                overrideYear: adminStudentYear,
              )),
        );
        emit(state.copyWith(
          isPosting: false,
          isPosted: true,
          postedAnnouncement: results.isNotEmpty ? results.first : null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isPosting: false, error: e.toString()));
    }
  }

  /// Creates one Assignment (which auto-creates a linked Announcement) for
  /// [courseId], uploads any selected files, and returns the Announcement.
  Future<Announcement?> _createAssignment({
    required String courseId,
    int? cloneFromAnnouncementId,
  }) async {
    final assignment = await _assignmentDs.createAssignment(
      materialId: courseId,
      title: state.title,
      description: state.details.isNotEmpty ? state.details : null,
      deadline: state.deadline ?? DateTime.now().add(const Duration(days: 7)),
    );

    final annId = assignment.announcementId;
    final newFiles = state.attachments.where((a) => !a.isServerFile).toList();

    if (annId != null && newFiles.isNotEmpty) {
      await Future.wait(newFiles.map((item) async {
        try {
          await _repo.uploadAnnouncementFile(
            announcementId: annId,
            materialId: courseId,
            title: item.name,
            fileType: _toBackendFileType(item),
            filePath: item.filePath,
            linkUrl: item.isLink ? item.url : null,
          );
        } catch (_) {}
      }));
    }

    if (annId != null && cloneFromAnnouncementId != null) {
      final hasServerFiles = state.attachments.any((a) => a.isServerFile);
      if (hasServerFiles) {
        try {
          await _repo.cloneFilesToAnnouncement(
            fromAnnouncementId: cloneFromAnnouncementId,
            toAnnouncementId: annId,
          );
        } catch (_) {}
      }
    }

    if (annId != null) {
      try {
        final ann = await _repo.getAnnouncementDetail(annId);
        try {
          await _repo.notifyAnnouncement(annId);
        } catch (_) {}
        return ann;
      } catch (_) {}
    }
    return null;
  }

  /// Updates (or creates) the Assignment linked to the announcement being edited.
  ///
  /// - If an Assignment already exists: update its deadline/title/description.
  /// - If no Assignment exists yet (type was changed to assignment in this edit):
  ///   create a new Assignment linked to the existing announcement so that the
  ///   backend can populate `deadline` in the AnnouncementOut response.
  Future<void> _updateAssignmentRecord() async {
    final assignmentId = _announcementToEdit?.assignmentId;
    final existingAnnId = int.tryParse(_announcementToEdit?.id ?? '');

    if (assignmentId == null) {
      // No linked assignment yet — create one attached to the existing announcement.
      if (state.postType != AnnouncementType.assignment) return;
      if (existingAnnId == null) return;
      final courseId = _announcementToEdit?.targetCourseId ??
          state.selectedCourseId ??
          state.selectedOptions.firstOrNull ??
          '';
      try {
        await _assignmentDs.createAssignment(
          materialId: courseId,
          title: state.title,
          description: state.details.isNotEmpty ? state.details : null,
          deadline: state.deadline ?? DateTime.now().add(const Duration(days: 7)),
          announcementId: existingAnnId,
        );
      } catch (_) {}
      return;
    }

    // Existing assignment — update deadline/title/description.
    try {
      await _assignmentDs.updateAssignment(assignmentId, {
        'title': state.title,
        if (state.details.isNotEmpty) 'description': state.details,
        if (state.deadline != null)
          'deadline': state.deadline!.toUtc().toIso8601String(),
      });
    } catch (_) {}
  }

  /// Creates or updates a single announcement, optionally targeting [courseId].
  /// In edit mode [courseId] is ignored — the existing course is preserved.
  Future<Announcement> _postAnnouncement({
    String? courseId,
    forceCreate = false,
    int? overrideYear,
  }) async {
    final payload = _buildAnnouncementPayload(courseId: courseId, overrideYear: overrideYear);
    final Announcement base;

    if (isEditMode && !forceCreate) {
      final id = int.parse(_announcementToEdit!.id);

      // Delete server files removed from the edit form
      final originalIds = _announcementToEdit!.attachments
          .where((a) => a.fileId != null)
          .map((a) => a.fileId!)
          .toSet();
      final keptIds = state.attachments
          .where((a) => a.isServerFile && a.fileId != null)
          .map((a) => a.fileId!)
          .toSet();
      final removedIds = originalIds.difference(keptIds);
      await Future.wait(removedIds.map((fid) async {
        try {
          await _repo.deleteFile(fid);
        } catch (_) {}
      }));

      base = await _repo.updateAnnouncement(id, payload);
    } else {
      base = await _repo.createAnnouncement(payload);

      // Clone server-side files from original announcement to the new copy
      if (forceCreate && _announcementToEdit != null) {
        final hasServerFiles = state.attachments.any((a) => a.isServerFile);
        if (hasServerFiles) {
          try {
            await _repo.cloneFilesToAnnouncement(
              fromAnnouncementId: int.parse(_announcementToEdit!.id),
              toAnnouncementId: int.parse(base.id),
            );
          } catch (_) {}
        }
      }
    }

    // Upload new local files (best-effort)
    final effectiveCourseId =
        courseId ?? state.selectedCourseId ?? state.selectedOptions.firstOrNull;
    final newFiles = state.attachments.where((a) => !a.isServerFile).toList();

    final annId = int.parse(base.id);
    // Admin has no course; specific-students mode has optional course filter
    final canUpload = state.role == AnnounRole.admin ||
        effectiveCourseId != null ||
        state.drAudienceType == DrAudienceType.specificStudents;
    if (canUpload && newFiles.isNotEmpty) {
      await Future.wait(newFiles.map((item) async {
        try {
          await _repo.uploadAnnouncementFile(
            announcementId: annId,
            materialId:
                effectiveCourseId, // null for admin → backend accepts it
            title: item.name,
            fileType: _toBackendFileType(item),
            filePath: item.filePath,
            linkUrl: item.isLink ? item.url : null,
          );
        } catch (_) {}
      }));
      final full = await _repo.getAnnouncementDetail(annId);
      try {
        await _repo.notifyAnnouncement(annId);
      } catch (_) {}
      return full;
    }

    // Refresh via detail endpoint so deadline (from the assignment relationship)
    // is always populated in the returned object.
    if (isEditMode && !forceCreate) {
      try {
        final refreshed = await _repo.getAnnouncementDetail(annId);
        try {
          await _repo.notifyAnnouncement(annId);
        } catch (_) {}
        return refreshed;
      } catch (_) {}
    }

    try {
      await _repo.notifyAnnouncement(annId);
    } catch (_) {}
    return base;
  }

  static String _toBackendFileType(AddAnnounAttachmentItem item) {
    if (item.isLink) return 'link';
    final n = item.name.toLowerCase();
    if (n.endsWith('.pdf')) return 'pdf';
    if (n.endsWith('.jpg') ||
        n.endsWith('.jpeg') ||
        n.endsWith('.png') ||
        n.endsWith('.gif') ||
        n.endsWith('.webp')) {
      return 'image';
    }
    if (n.endsWith('.doc') || n.endsWith('.docx')) return 'word';
    if (n.endsWith('.ppt') || n.endsWith('.pptx')) return 'ppt';
    if (n.endsWith('.zip')) return 'zip';
    if (n.endsWith('.rar')) return 'rar';
    return 'file';
  }

  Map<String, dynamic> _buildAnnouncementPayload(
      {String? courseId, int? overrideYear}) {
    final s = state;
    final payload = <String, dynamic>{
      'title': s.title,
      'content': s.details,
      'announcement_type': s.postType.toApiString,
      'priority': s.priority.toApiString,
    };

    if (s.role == AnnounRole.admin) {
      _applyAdminTarget(payload, overrideYear: overrideYear);
    } else {
      _applyDoctorTarget(payload, courseId: courseId);
    }

    return payload;
  }

  void _applyAdminTarget(Map<String, dynamic> p, {int? overrideYear}) {
    final ut = state.adminUserType;
    if (ut == null) return;

    switch (ut) {
      case AdminUserType.all:
        p['target_type'] = 'all';

      case AdminUserType.students:
        if (state.selectedLevels.isEmpty) {
          // No level filter → all students
          p['target_type'] = 'role';
          p['target_role'] = 'STU';
        } else {
          // overrideYear is set from post() loop
          p['target_type'] = 'level';
          p['target_year'] = overrideYear;
          // Levels 3/4 belong to specific departments; 1/2 are General
          if (overrideYear != null && overrideYear >= 3) {
            final specificDept = state.selectedDepartments
                .where((d) => d != 'General')
                .firstOrNull;
            if (specificDept != null) p['target_department'] = specificDept;
          }
        }

      case AdminUserType.doctors:
        p['target_type'] = 'role';
        p['target_role'] = 'DR';

      case AdminUserType.ta:
        p['target_type'] = 'role';
        p['target_role'] = 'TA';

      case AdminUserType.specificUsers:
        p['target_type'] = 'users';
        p['target_user_ids'] = state.selectedRecipientIds.toList();
    }
  }

  void _applyDoctorTarget(Map<String, dynamic> p, {String? courseId}) {
    if (state.drAudienceType == DrAudienceType.specificStudents) {
      p['target_type'] = 'users';
      p['target_user_ids'] = state.selectedRecipientIds.toList();
      return;
    }
    final id =
        courseId ?? state.selectedCourseId ?? state.selectedOptions.firstOrNull;
    if (id == null) return;
    p['target_type'] = 'course';
    p['target_course_id'] = id;
  }
}
