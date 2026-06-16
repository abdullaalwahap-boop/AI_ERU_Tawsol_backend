class CourseOption {
  final String id;
  final String name;
  final String? departmentCourse;

  const CourseOption({
    required this.id,
    required this.name,
    this.departmentCourse,
  });

  factory CourseOption.fromJson(Map<String, dynamic> json) => CourseOption(
        id: json['material_id'] as String,
        name: json['name'] as String,
        departmentCourse: json['department_course'] as String?,
      );

  String get displayName => '$name · $id';
}
