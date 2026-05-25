/// Central registry for all backend API endpoints.
///
/// Change [baseUrl] to switch between local dev, staging, and production.
class ApiConstants {
  ApiConstants._();

  // ─── Base ─────────────────────────────────────────────────────────────────────
  static const String baseUrl = 'http://10.0.2.2:8000';

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

  // ─── Course Content ───────────────────────────────────────────────────────────
  static const String announcements = '/announcements';
  static String courseAssignments(String materialId) => '/assignments/$materialId';
  static String courseFiles(String materialId) => '/files/$materialId';

  // ─── Chat ─────────────────────────────────────────────────────────────────────
  static const String chatConversations = '/chat/conversations';
  static const String chatSend = '/chat/send';
  static const String chatSearch = '/chat/search';
  static String chatHistory(int userId1, int userId2) =>
      '/chat/history/$userId1/$userId2';
  static String chatSeen(int otherUserId) => '/chat/seen/$otherUserId';
  static String chatOnlineStatus(int userId) => '/chat/online/$userId';
  static String chatPin(int partnerId) => '/chat/pin/$partnerId';
  static String wsChat(int userId) =>
      '${baseUrl.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://')}/chat/ws/$userId';

  // ─── Support ──────────────────────────────────────────────────────────────────
  static const String contactUs = '/contact/';

  // ─── Timeouts ─────────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
