/// Central registry for all backend API endpoints.
///
/// Change [baseUrl] to switch between local dev, staging, and production.
class ApiConstants {
  ApiConstants._();

  // ─── Base ─────────────────────────────────────────────────────────────────────

  //?http://alfred-dell.local:8000 android //http://10.0.2.2:8000 VS

  // Production Vercel FastAPI backend connected to Neon PostgreSQL
  static const String baseUrl = 'https://ai-eru-tawsol-backend-weschool.vercel.app';

  // ─── Auth ─────────────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  // ─── User / Profile ───────────────────────────────────────────────────────────
  static const String me = '/users/me';
  static const String changePassword = '/users/me/password';
  static const String updatePicture = '/users/me/picture';

  // ─── Materials (Courses) ─────────────────────────────────────────────────────
  static String studentMaterials(int userId) => '/materials/student/$userId';
  static String teacherMaterials(int userId) => '/materials/teacher/$userId';

  // ─── Announcements ────────────────────────────────────────────────────────────
  static const String announcements = '/announcements';
  static String announcementById(int id) => '/announcements/$id';
  static String announcementMarkRead(int id) => '/announcements/$id/read';
  static const String announcementsUnreadCount = '/announcements/unread-count';
  static const String announcementsSent = '/announcements/sent';
  static const String announcementsRecipients = '/announcements/recipients';

  // ─── Assignments ──────────────────────────────────────────────────────────────
  static const String assignments = '/assignments';
  static const String assignmentsUpcoming = '/assignments/upcoming';
  static String assignmentDetail(int id) => '/assignments/detail/$id';
  static String assignmentById(int id) => '/assignments/$id';
  static String courseAssignments(String materialId) =>
      '/assignments/$materialId';

  // ─── Files ────────────────────────────────────────────────────────────────────
  static const String files = '/files';
  static const String filesClone = '/files/clone';
  static String fileById(int id) => '/files/$id';
  static String courseFiles(String materialId) => '/files/$materialId';

  // ─── Chat ─────────────────────────────────────────────────────────────────────
  static const String chatConversations = '/chat/conversations';
  static const String chatSend = '/chat/send';
  static const String chatUploadVoice = '/chat/upload/voice';
  static const String chatUploadFile = '/chat/upload/file';
  static const String chatSearch = '/chat/search';
  static const String chatOnline = '/chat/online';
  static String chatHistory(int userId1, int userId2) =>
      '/chat/history/$userId1/$userId2';
  static String chatMessage(int chatId) => '/chat/message/$chatId';
  static String chatSeen(int otherUserId) => '/chat/seen/$otherUserId';
  static String chatOnlineStatus(int userId) => '/chat/online/$userId';
  static String chatPin(int partnerId) => '/chat/pin/$partnerId';
  static String wsChat(int userId) =>
      '${baseUrl.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://')}/chat/ws/$userId';
  static String wsAnnouncements(int userId) =>
      '${baseUrl.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://')}/announcements/ws/$userId';

  // ─── Support ──────────────────────────────────────────────────────────────────
  static const String contactUs = '/contact/';

  // ─── Quiz (AI) ────────────────────────────────────────────────────────────────
  static const String quizGenerate = '/quiz/generate';
  static const String quizEvaluate = '/quiz/evaluate';

  // ─── Attendance (QR Code) ───────────────────────────────────────────────────
  static const String attendanceSessions = '/attendance/sessions';
  static String attendanceSessionDetail(int id) => '/attendance/sessions/$id';
  static String attendanceSessionClose(int id) => '/attendance/sessions/$id/close';
  static const String attendanceCheckIn = '/attendance/check-in';
  static const String attendanceMySummary = '/attendance/my-summary';

  // ─── Timeouts ─────────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
