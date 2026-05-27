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

  void localMarkAnnouncementRead(String id) {
    final current = state;
    if (current is! CourseDetailsLoaded) return;
    emit(current.copyWith(
      content: current.content.map((c) {
        final ann = c.announcement;
        if (ann == null || ann.id != id) return c;
        return c.withAnnouncement(ann.copyWith(isRead: true));
      }).toList(),
    ));
  }

  Future<void> refresh(CourseRole role, Course course) =>
      loadForRole(role, course);

  /// Re-fetches content without emitting CourseDetailsLoading,
  /// so the list updates silently when a WS event arrives.
  Future<void> silentRefresh(CourseRole role, Course course) async {
    final current = state;
    if (current is! CourseDetailsLoaded) return;
    try {
      final content = switch (role) {
        CourseRole.student => await _repo.getAllCourseContent(course.id),
        CourseRole.doctor  => await _repo.getDoctorCourseContent(course.id),
      };
      if (isClosed) return;
      emit(current.copyWith(content: content));
    } catch (_) {
      // silently ignore — user still sees previous data
    }
  }
}
