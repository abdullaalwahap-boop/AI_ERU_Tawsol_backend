import 'package:ai_eru_tawasol/features/announcement/data/datasources/assignment_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/assignment_model.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/assignment_repo.dart';
import 'package:dio/dio.dart';

class AssignmentRepoImpl implements AssignmentRepo {
  const AssignmentRepoImpl(this._ds);
  final AssignmentRemoteDatasource _ds;

  @override
  Future<List<Assignment>> getAssignments({
    String? status,
    int skip = 0,
    int limit = 50,
  }) =>
      _ds.getAssignments(status: status, skip: skip, limit: limit);

  @override
  Future<List<Assignment>> getUpcoming({int days = 7}) =>
      _ds.getUpcoming(days: days);

  @override
  Future<Assignment> getDetail(int id) => _ds.getDetail(id);

  @override
  Future<List<Assignment>> getCourseAssignments(String materialId) =>
      _ds.getCourseAssignments(materialId);

  @override
  Future<Assignment> createAssignment({
    required String materialId,
    required String title,
    String? description,
    required DateTime deadline,
    String? linkUrl,
    String? fileType,
    String? textContent,
    MultipartFile? file,
  }) =>
      _ds.createAssignment(
        materialId: materialId,
        title: title,
        description: description,
        deadline: deadline,
        linkUrl: linkUrl,
        fileType: fileType,
        textContent: textContent,
        file: file,
      );

  @override
  Future<Assignment> updateAssignment(int id, Map<String, dynamic> payload) =>
      _ds.updateAssignment(id, payload);

  @override
  Future<void> deleteAssignment(int id) => _ds.deleteAssignment(id);
}
