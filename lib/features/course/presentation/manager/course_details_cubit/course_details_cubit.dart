import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  CourseDetailsCubit(this._repo) : super(CourseDetailsInitial());

  final CourseRepo _repo;

  Future<void> loadForStudent(Course course) async {
    emit(CourseDetailsLoading());
    try {
      final all = await _repo.getAllCourseContent(course.id);
      if (isClosed) return;
      emit(CourseDetailsLoaded(course: course, content: all));
    } catch (e) {
      if (isClosed) return;
      emit(CourseDetailsError(e.toString()));
    }
  }

  Future<void> loadForDoctor(Course course) async {
    emit(CourseDetailsLoading());
    try {
      final content = await _repo.getDoctorCourseContent(course.id);
      if (isClosed) return;
      emit(CourseDetailsLoaded(course: course, content: content));
    } catch (e) {
      if (isClosed) return;
      emit(CourseDetailsError(e.toString()));
    }
  }

  Future<void> loadForRole(CourseRole role, Course course) async {
    switch (role) {
      case CourseRole.student:
        return loadForStudent(course);
      case CourseRole.doctor:
        return loadForDoctor(course);
    }
  }

  void filterContent(ContentType? type) {
    final current = state;
    if (current is! CourseDetailsLoaded) return;
    emit(current.copyWith(
      activeFilter: type,
      clearFilter: type == null,
    ));
  }

  void removeContent(String id) {
    final current = state;
    if (current is! CourseDetailsLoaded) return;
    emit(current.copyWith(
      content: current.content.where((c) => c.id != id).toList(),
    ));
  }

  void updateAnnouncementContent(Announcement updated) {
    final current = state;
    if (current is! CourseDetailsLoaded) return;
    emit(current.copyWith(
      content: current.content.map((c) {
        if (c.announcement?.id == updated.id) return c.withAnnouncement(updated);
        return c;
      }).toList(),
    ));
  }

  Future<void> refresh(CourseRole role, Course course) =>
      loadForRole(role, course);
}
