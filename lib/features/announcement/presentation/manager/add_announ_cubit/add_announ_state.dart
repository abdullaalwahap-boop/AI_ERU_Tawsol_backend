part of 'add_announ_cubit.dart';

class AddAnnounState extends Equatable {
  final AnnounRole role;
  final AnnouncementType postType;
  final String title;
  final String details;
  final AnnouncementPriority priority;

  // ── Doctor / TA audience ──────────────────────────────────────────────────
  final List<CourseOption> courses;
  final bool isLoadingCourses;
  final String? selectedCourseId;
  // keep Set<String> for backward compat with existing audience chips widget
  final Set<String> selectedOptions;

  // ── Admin audience ────────────────────────────────────────────────────────
  final AdminUserType? adminUserType;
  final Set<String> selectedDepartments;
  final Set<String> selectedLevels;
  final int? targetYear;

  // ── Recipient search (admin specificUsers / doctor specific students) ─────
  final List<RecipientUser> recipients;
  final bool isLoadingRecipients;
  final Set<int> selectedRecipientIds;

  // ── Assignment-specific ───────────────────────────────────────────────────
  final DateTime? deadline;

  // ── Attachments ───────────────────────────────────────────────────────────
  final List<AddAnnounAttachmentItem> attachments;

  // ── Post state ────────────────────────────────────────────────────────────
  final bool isPosting;
  final bool isPosted;
  final Announcement? postedAnnouncement;
  final String? error;

  const AddAnnounState({
    required this.role,
    required this.postType,
    required this.title,
    required this.details,
    this.priority = AnnouncementPriority.normal,
    this.courses = const [],
    this.isLoadingCourses = false,
    this.selectedCourseId,
    required this.selectedOptions,
    this.adminUserType,
    required this.selectedDepartments,
    required this.selectedLevels,
    this.targetYear,
    this.recipients = const [],
    this.isLoadingRecipients = false,
    this.selectedRecipientIds = const {},
    this.deadline,
    this.attachments = const [],
    this.isPosting = false,
    this.isPosted = false,
    this.postedAnnouncement,
    this.error,
  });

  factory AddAnnounState.initial(AnnounRole role) => AddAnnounState(
        role: role,
        postType: AnnouncementType.normal,
        title: '',
        details: '',
        selectedOptions: const {},
        selectedDepartments: const {},
        selectedLevels: const {},
      );

  // ── Derived ───────────────────────────────────────────────────────────────

  bool get supportsAttachments =>
      postType == AnnouncementType.materialFile ||
      postType == AnnouncementType.assignment;

  bool get isEditMode => false; // overridden in cubit

  bool get canPost {
    if (title.trim().isEmpty || details.trim().isEmpty) return false;
    // Types that show the attachment section require at least one attachment
    if (supportsAttachments && attachments.isEmpty) return false;
    // Assignments require a deadline
    if (postType == AnnouncementType.assignment && deadline == null) {
      return false;
    }
    if (role == AnnounRole.admin) {
      if (adminUserType == null) return false;
      if (adminUserType!.needsDepartment && selectedDepartments.isEmpty) {
        return false;
      }
      if (adminUserType!.needsYear && targetYear == null) return false;
      if (adminUserType!.needsRecipientSearch &&
          selectedRecipientIds.isEmpty) {
        return false;
      }
      return true;
    }
    // Doctor / TA need a course selected
    return selectedCourseId != null || selectedOptions.isNotEmpty;
  }

  CourseOption? get selectedCourse => courses.isEmpty
      ? null
      : courses.where((c) => c.id == selectedCourseId).isNotEmpty
          ? courses.firstWhere((c) => c.id == selectedCourseId)
          : null;

  @override
  List<Object?> get props => [
        role,
        postType,
        title,
        details,
        priority,
        courses,
        isLoadingCourses,
        selectedCourseId,
        selectedOptions,
        adminUserType,
        selectedDepartments,
        selectedLevels,
        targetYear,
        recipients,
        isLoadingRecipients,
        selectedRecipientIds,
        deadline,
        attachments,
        isPosting,
        isPosted,
        postedAnnouncement,
        error,
      ];

  AddAnnounState copyWith({
    AnnouncementType? postType,
    String? title,
    String? details,
    AnnouncementPriority? priority,
    List<CourseOption>? courses,
    bool? isLoadingCourses,
    String? selectedCourseId,
    bool clearCourse = false,
    Set<String>? selectedOptions,
    AdminUserType? adminUserType,
    Set<String>? selectedDepartments,
    Set<String>? selectedLevels,
    int? targetYear,
    bool clearYear = false,
    List<RecipientUser>? recipients,
    bool? isLoadingRecipients,
    Set<int>? selectedRecipientIds,
    DateTime? deadline,
    bool clearDeadline = false,
    List<AddAnnounAttachmentItem>? attachments,
    bool? isPosting,
    bool? isPosted,
    Announcement? postedAnnouncement,
    String? error,
    bool clearError = false,
  }) {
    return AddAnnounState(
      role: role,
      postType: postType ?? this.postType,
      title: title ?? this.title,
      details: details ?? this.details,
      priority: priority ?? this.priority,
      courses: courses ?? this.courses,
      isLoadingCourses: isLoadingCourses ?? this.isLoadingCourses,
      selectedCourseId:
          clearCourse ? null : (selectedCourseId ?? this.selectedCourseId),
      selectedOptions: selectedOptions ?? this.selectedOptions,
      adminUserType: adminUserType ?? this.adminUserType,
      selectedDepartments: selectedDepartments ?? this.selectedDepartments,
      selectedLevels: selectedLevels ?? this.selectedLevels,
      targetYear: clearYear ? null : (targetYear ?? this.targetYear),
      recipients: recipients ?? this.recipients,
      isLoadingRecipients: isLoadingRecipients ?? this.isLoadingRecipients,
      selectedRecipientIds: selectedRecipientIds ?? this.selectedRecipientIds,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      attachments: attachments ?? this.attachments,
      isPosting: isPosting ?? this.isPosting,
      isPosted: isPosted ?? this.isPosted,
      postedAnnouncement: postedAnnouncement ?? this.postedAnnouncement,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
