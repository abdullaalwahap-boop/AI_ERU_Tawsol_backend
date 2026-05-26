import 'package:ai_eru_tawasol/features/announcement/data/models/assignment_model.dart';
import 'package:dio/dio.dart';

abstract class AssignmentRepo {
  Future<List<Assignment>> getAssignments({String? status, int skip, int limit});
  Future<List<Assignment>> getUpcoming({int days});
  Future<Assignment> getDetail(int id);
  Future<List<Assignment>> getCourseAssignments(String materialId);
  Future<Assignment> createAssignment({
    required String materialId,
    required String title,
    String? description,
    required DateTime deadline,
    String? linkUrl,
    String? fileType,
    String? textContent,
    MultipartFile? file,
  });
  Future<Assignment> updateAssignment(int id, Map<String, dynamic> payload);
  Future<void> deleteAssignment(int id);
}
