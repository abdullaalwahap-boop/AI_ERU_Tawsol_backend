enum AnnouncementPriority {
  normal,
  important,
  urgent;

  static AnnouncementPriority fromString(String v) => switch (v) {
        'important' => important,
        'urgent' => urgent,
        _ => normal,
      };

  String get toApiString => switch (this) {
        important => 'important',
        urgent => 'urgent',
        normal => 'normal',
      };
}
