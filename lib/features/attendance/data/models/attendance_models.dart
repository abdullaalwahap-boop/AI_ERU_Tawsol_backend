class AttendanceCheckInResult {
  const AttendanceCheckInResult({
    required this.message,
    required this.recordId,
    required this.sessionId,
    required this.materialId,
    required this.courseName,
    required this.scannedAt,
    required this.status,
  });

  final String message;
  final int recordId;
  final int sessionId;
  final String materialId;
  final String courseName;
  final DateTime scannedAt;
  final String status;

  factory AttendanceCheckInResult.fromJson(Map<String, dynamic> json) {
    return AttendanceCheckInResult(
      message: json['message'] as String? ?? 'تم تسجيل الحضور',
      recordId: json['record_id'] as int? ?? 0,
      sessionId: json['session_id'] as int? ?? 0,
      materialId: json['material_id'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      scannedAt: json['scanned_at'] != null
          ? DateTime.tryParse(json['scanned_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? 'PRESENT',
    );
  }
}

class CourseAttendanceSummary {
  const CourseAttendanceSummary({
    required this.materialId,
    required this.courseName,
    required this.attendedSessions,
    required this.totalSessions,
    required this.attendanceRate,
  });

  final String materialId;
  final String courseName;
  final int attendedSessions;
  final int totalSessions;
  final double attendanceRate;

  factory CourseAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return CourseAttendanceSummary(
      materialId: json['material_id'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      attendedSessions: json['attended_sessions'] as int? ?? 0,
      totalSessions: json['total_sessions'] as int? ?? 0,
      attendanceRate: (json['attendance_rate'] as num?)?.toDouble() ?? 100.0,
    );
  }
}
