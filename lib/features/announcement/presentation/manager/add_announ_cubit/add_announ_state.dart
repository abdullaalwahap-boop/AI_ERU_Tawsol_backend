part of 'add_announ_cubit.dart';

class AddAnnounState extends Equatable {
  final AnnounRole role;
  final AnnouncementType postType;
  final String title;
  final String details;
  final AddAnnounAudienceType? audienceType;
  final Set<String> selectedOptions;
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
    this.audienceType,
    required this.selectedOptions,
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
        // Doctor always targets a subject — pre-select the type so no extra tap needed.
        audienceType:
            role == AnnounRole.doctor ? AddAnnounAudienceType.subject : null,
        selectedOptions: const {},
      );

  bool get supportsAttachments =>
      postType == AnnouncementType.materialFile ||
      postType == AnnouncementType.assignment;

  bool get canPost {
    if (title.trim().isEmpty || details.trim().isEmpty) return false;
    if (audienceType == null) return false;
    if (audienceType == AddAnnounAudienceType.everyone) return true;
    return selectedOptions.isNotEmpty;
  }

  List<AddAnnounAudienceType> audienceTypesForRole() {
    switch (role) {
      case AnnounRole.doctor:
        return [AddAnnounAudienceType.subject];
      case AnnounRole.admin:
        return [
          AddAnnounAudienceType.everyone,
          AddAnnounAudienceType.department,
          AddAnnounAudienceType.level,
        ];
      case AnnounRole.student:
        return [];
    }
  }

  @override
  List<Object?> get props => [
        role,
        postType,
        title,
        details,
        audienceType,
        selectedOptions,
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
    AddAnnounAudienceType? audienceType,
    Set<String>? selectedOptions,
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
      audienceType: audienceType ?? this.audienceType,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      attachments: attachments ?? this.attachments,
      priority: priority ?? this.priority,
      isPosting: isPosting ?? this.isPosting,
      isPosted: isPosted ?? this.isPosted,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
