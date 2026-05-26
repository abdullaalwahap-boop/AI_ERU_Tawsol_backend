import 'package:ai_eru_tawasol/features/announcement/data/models/assignment_model.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/assignment_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'assignment_state.dart';

class AssignmentCubit extends Cubit<AssignmentState> {
  AssignmentCubit(this._repo) : super(AssignmentInitial());

  final AssignmentRepo _repo;

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadAll({String? status}) async {
    emit(AssignmentLoading());
    try {
      final list = await _repo.getAssignments(status: status);
      if (isClosed) return;
      emit(AssignmentLoaded(assignments: list, statusFilter: status));
    } catch (e) {
      if (isClosed) return;
      emit(AssignmentError(e.toString()));
    }
  }

  Future<void> loadUpcoming({int days = 7}) async {
    emit(AssignmentLoading());
    try {
      final list = await _repo.getUpcoming(days: days);
      if (isClosed) return;
      emit(AssignmentLoaded(assignments: list, statusFilter: 'upcoming'));
    } catch (e) {
      if (isClosed) return;
      emit(AssignmentError(e.toString()));
    }
  }

  Future<void> loadForCourse(String materialId) async {
    emit(AssignmentLoading());
    try {
      final list = await _repo.getCourseAssignments(materialId);
      if (isClosed) return;
      emit(AssignmentLoaded(assignments: list));
    } catch (e) {
      if (isClosed) return;
      emit(AssignmentError(e.toString()));
    }
  }

  Future<void> refresh({String? status}) => loadAll(status: status);

  // ── Filters ───────────────────────────────────────────────────────────────

  void filterByStatus(String? status) {
    final current = state;
    if (current is! AssignmentLoaded) return;
    emit(current.copyWith(statusFilter: status, clearStatus: status == null));
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<bool> deleteAssignment(int id) async {
    final current = state;
    if (current is! AssignmentLoaded) return false;
    try {
      emit(AssignmentActionLoading());
      await _repo.deleteAssignment(id);
      final updated =
          current.assignments.where((a) => a.id != id).toList();
      emit(current.copyWith(assignments: updated));
      return true;
    } catch (e) {
      emit(AssignmentError(e.toString()));
      return false;
    }
  }

  void prependAssignment(Assignment assignment) {
    final current = state;
    if (current is! AssignmentLoaded) return;
    emit(current.copyWith(
        assignments: [assignment, ...current.assignments]));
  }

  void replaceAssignment(Assignment updated) {
    final current = state;
    if (current is! AssignmentLoaded) return;
    emit(current.copyWith(
      assignments:
          current.assignments.map((a) => a.id == updated.id ? updated : a).toList(),
    ));
  }
}
