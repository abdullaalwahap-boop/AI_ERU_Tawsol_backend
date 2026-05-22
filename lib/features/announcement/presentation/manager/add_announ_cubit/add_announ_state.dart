part of 'add_announ_cubit.dart';

class AddAnnounState extends Equatable {
  final AnnounRole role;
  final AnnouncementType postType;
  final String title;
  final String details;

  // ── Doctor audience ───────────────────────────────────────────────────────
  final Set<String> selectedOptions;

  // ── Admin audience ────────────────────────────────────────────────────────
  final AdminUserType? adminUserType;
  final Set<String> selectedDepartments;
  final Set<String> selectedLevels;

  // ── Shared ────────────────────────────────────────────────────────────────
  final List<AddAnnounAttachmentItem> attachments;
  final AnnouncementPriority priority;
  final bool isPosting;
  final bool isPosted;
  final String? error;

  const AddAnnounState({
    required this.role,
    required this.postType,
    required this.title,
    required this.details,
    required this.selectedOptions,
    this.adminUserType,
    required this.selectedDepartments,
    required this.selectedLevels,
    this.attachments = const [],
    this.priority = AnnouncementPriority.normal,
    this.isPosting = false,
    this.isPosted = false,
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

  bool get supportsAttachments =>
      postType == AnnouncementType.materialFile ||
      postType == AnnouncementType.assignment;

  bool get canPost {
    if (title.trim().isEmpty || details.trim().isEmpty) return false;
    if (role == AnnounRole.admin) return adminUserType != null;
    return selectedOptions.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        role,
        postType,
        title,
        details,
        selectedOptions,
        adminUserType,
        selectedDepartments,
        selectedLevels,
        attachments,
        priority,
        isPosting,
        isPosted,
        error,
      ];

  AddAnnounState copyWith({
    AnnouncementType? postType,
    String? title,
    String? details,
    Set<String>? selectedOptions,
    AdminUserType? adminUserType,
    Set<String>? selectedDepartments,
    Set<String>? selectedLevels,
    List<AddAnnounAttachmentItem>? attachments,
    AnnouncementPriority? priority,
    bool? isPosting,
    bool? isPosted,
    String? error,
    bool clearError = false,
  }) {
    return AddAnnounState(
      role: role,
      postType: postType ?? this.postType,
      title: title ?? this.title,
      details: details ?? this.details,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      adminUserType: adminUserType ?? this.adminUserType,
      selectedDepartments: selectedDepartments ?? this.selectedDepartments,
      selectedLevels: selectedLevels ?? this.selectedLevels,
      attachments: attachments ?? this.attachments,
      priority: priority ?? this.priority,
      isPosting: isPosting ?? this.isPosting,
      isPosted: isPosted ?? this.isPosted,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
