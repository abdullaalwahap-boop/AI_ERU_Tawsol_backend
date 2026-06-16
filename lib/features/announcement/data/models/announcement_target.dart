enum AnnouncementTarget {
  all,
  course,
  courseDepartment,
  department,
  level,
  student,
  users,
  role;

  static AnnouncementTarget fromString(String v) => switch (v) {
        'course' => course,
        'course_department' => courseDepartment,
        'department' => department,
        'level' => level,
        'student' => student,
        'users' => users,
        'role' => role,
        _ => all,
      };

  String get toApiString => switch (this) {
        course => 'course',
        courseDepartment => 'course_department',
        department => 'department',
        level => 'level',
        student => 'student',
        users => 'users',
        role => 'role',
        all => 'all',
      };
}

extension AnnouncementTargetExt on AnnouncementTarget {
  String get label => switch (this) {
        AnnouncementTarget.all => 'All Students',
        AnnouncementTarget.course => 'Course',
        AnnouncementTarget.courseDepartment => 'Dept. Course',
        AnnouncementTarget.department => 'Department',
        AnnouncementTarget.level => 'Level',
        AnnouncementTarget.student => 'Student',
        AnnouncementTarget.users => 'Selected Users',
        AnnouncementTarget.role => 'Role',
      };
}
