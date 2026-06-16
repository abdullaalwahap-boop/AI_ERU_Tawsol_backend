import 'package:ai_eru_tawasol/features/course/data/models/course.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_enums.dart';

class CourseDetailsArgs {
  final Course course;
  final CourseRole role;

  const CourseDetailsArgs({required this.course, required this.role});
}
