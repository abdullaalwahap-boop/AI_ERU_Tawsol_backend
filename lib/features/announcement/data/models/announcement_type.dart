enum AnnouncementType {
  normal,
  materialFile,
  assignment;

  static AnnouncementType fromString(String v) => switch (v) {
        'material_file' => materialFile,
        'assignment' => assignment,
        _ => normal,
      };

  String get toApiString => switch (this) {
        materialFile => 'material_file',
        assignment => 'assignment',
        normal => 'normal',
      };
}
