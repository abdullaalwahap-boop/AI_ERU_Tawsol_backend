import 'package:flutter/material.dart' show Color;

class Course {
  final String id;
  final String name;
  final String code;
  final String doctorName;
  final String description;
  final Color accentColor;
  final int studentCount;
  final int contentCount;
  final int duration;

  const Course({
    required this.id,
    required this.name,
    required this.code,
    required this.doctorName,
    required this.description,
    required this.accentColor,
    required this.studentCount,
    required this.contentCount,
    this.duration = 0,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final id = json['material_id'] as String;
    return Course(
      id: id,
      code: id,
      name: json['name'] as String,
      doctorName: json['teacher_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      accentColor: _accentColorFromId(id),
      studentCount: json['student_count'] as int? ?? 0,
      contentCount: json['content_count'] as int? ?? 0,
      duration: json['duration'] as int? ?? 0,
    );
  }

  String get initials {
    final words = name.trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  static Color _accentColorFromId(String id) {
    const colors = [
      Color(0xff3D6FFF),
      Color(0xff7C3AED),
      Color(0xff059669),
      Color(0xffEA580C),
      Color(0xff0891B2),
      Color(0xffF59E0B),
      Color(0xffEF4444),
      Color(0xff10B981),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }
}
