import 'dart:async';

import 'package:ai_eru_tawasol/core/events/announcement_change_notifier.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/data/services/announcement_ws_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_ws_events.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/voice_recorder_service.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:mocktail/mocktail.dart';

// ── Internal mocks ─────────────────────────────────────────────────────────

class _MockSecureStorage extends Mock implements SecureStorageService {}

class _FakeAnnouncementWsService extends AnnouncementWsService {
  _FakeAnnouncementWsService() : super(_MockSecureStorage());

  @override
  Future<void> ensureConnected() async {}

  @override
  bool get isConnected => false;
}

class _FakeChatWsService implements ChatWebSocketService {
  final _ctrl = StreamController<WsEvent>.broadcast();

  @override
  Stream<WsEvent> get events => _ctrl.stream;

  @override
  bool get isConnected => false;

  @override
  Future<void> ensureConnected() async {}

  @override
  void disconnect() {}

  @override
  void dispose() => _ctrl.close();

  @override
  void sendSeen(int senderId) {}

  @override
  void sendText(
      {required int receiverId, required String text, int? replyToId}) {}

  @override
  void sendVoice(
      {required int receiverId,
      required int durationSeconds,
      String? fileUrl,
      String? fileName,
      int? fileSizeBytes,
      int? replyToId}) {}

  @override
  void sendFile(
      {required int receiverId,
      required String contentType,
      required String fileUrl,
      required String fileName,
      required int fileSizeBytes,
      int? replyToId}) {}

  @override
  void sendTyping({required int receiverId, required bool isTyping}) {}
}

class MockAnnounRepo extends Mock implements AnnounRepo {}

class MockChatRepo extends Mock implements ChatRepo {}

class MockCourseRepo extends Mock implements CourseRepo {}

class MockProfileRepo extends Mock implements ProfileRepo {}

// ── Public API ─────────────────────────────────────────────────────────────

/// Registers the minimal GetIt services needed by widgets that call getIt
/// in initState (AnnounViewBody, ChatInputBar).
///
/// Call in [setUp] and pair with [tearDownTestGetIt] in [tearDown].
void setupTestGetIt({
  AnnounRepo? announRepo,
  ChatRepo? chatRepo,
  CourseRepo? courseRepo,
  ProfileRepo? profileRepo,
}) {
  if (!getIt.isRegistered<AnnouncementChangeNotifier>()) {
    getIt.registerSingleton<AnnouncementChangeNotifier>(
      AnnouncementChangeNotifier(),
    );
  }
  if (!getIt.isRegistered<AnnouncementWsService>()) {
    getIt.registerSingleton<AnnouncementWsService>(
      _FakeAnnouncementWsService(),
    );
  }
  if (!getIt.isRegistered<ChatWebSocketService>()) {
    getIt.registerSingleton<ChatWebSocketService>(_FakeChatWsService());
  }
  if (!getIt.isRegistered<VoiceRecorderService>()) {
    getIt.registerSingleton<VoiceRecorderService>(VoiceRecorderService());
  }
  if (announRepo != null && !getIt.isRegistered<AnnounRepo>()) {
    getIt.registerSingleton<AnnounRepo>(announRepo);
  }
  if (chatRepo != null && !getIt.isRegistered<ChatRepo>()) {
    getIt.registerSingleton<ChatRepo>(chatRepo);
  }
  if (courseRepo != null && !getIt.isRegistered<CourseRepo>()) {
    getIt.registerSingleton<CourseRepo>(courseRepo);
  }
  if (profileRepo != null && !getIt.isRegistered<ProfileRepo>()) {
    getIt.registerSingleton<ProfileRepo>(profileRepo);
  }

  final storage = _MockSecureStorage();
  when(() => storage.getUserId()).thenAnswer((_) async => 1);
  if (!getIt.isRegistered<SecureStorageService>()) {
    getIt.registerSingleton<SecureStorageService>(storage);
  }
}

void tearDownTestGetIt() => getIt.reset();
