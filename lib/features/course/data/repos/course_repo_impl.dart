import 'package:ai_eru_tawasol/features/course/data/datasources/course_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';

class CourseRepoImpl implements CourseRepo {
  const CourseRepoImpl(this._datasource);

  final CourseRemoteDatasource _datasource;

  @override
  Future<List<Course>> getStudentCourses() => _datasource.getStudentCourses();

  @override
  Future<List<Course>> getDoctorCourses() => _datasource.getTeacherCourses();

  @override
  Future<List<CourseContent>> getAllCourseContent(String courseId) =>
      _datasource.getCourseContent(courseId);

  @override
  Future<List<CourseContent>> getDoctorCourseContent(String courseId) =>
      _datasource.getCourseContent(courseId);

  @override
  Future<List<CourseContent>> getAdminCourseContent(String courseId) async =>
      const [];
}
