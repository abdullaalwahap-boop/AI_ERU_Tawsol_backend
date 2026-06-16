import 'dart:async';

import 'package:ai_eru_tawasol/core/events/announcement_change_notifier.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/data/services/announcement_ws_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_ws_events.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/audio_player_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/voice_recorder_service.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_bottom_navigation_bar.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_floating_action_button.dart.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_view_body.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_app_wrapper.dart';

// ── Fakes ────────────────────────────────────────────────────────────────────

class _MockSecureStorage extends Mock implements SecureStorageService {}

class _MockAnnounRepo extends Mock implements AnnounRepo {}

class _MockChatRepo extends Mock implements ChatRepo {}

class _MockCourseRepo extends Mock implements CourseRepo {}

class _MockProfileRepo extends Mock implements ProfileRepo {}

class _MockAudioPlayerService extends Mock implements AudioPlayerService {}

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

// ── Setup helper ──────────────────────────────────────────────────────────────

late _MockSecureStorage _storage;

void _fullGetItSetup() {
  getIt.reset();

  _storage = _MockSecureStorage();
  when(() => _storage.getUserId()).thenAnswer((_) async => 1);
  when(() => _storage.getUserType()).thenAnswer((_) async => 'STU');
  when(() => _storage.getAccessToken()).thenAnswer((_) async => null);

  final annRepo = _MockAnnounRepo();
  when(() => annRepo.getAllAnnouncements()).thenAnswer((_) async => []);
  when(() => annRepo.getMyAnnouncements()).thenAnswer((_) async => []);
  when(() => annRepo.getAdminAnnouncements()).thenAnswer((_) async => []);

  final chatRepo = _MockChatRepo();
  when(() => chatRepo.getConversations()).thenAnswer((_) async => []);

  final courseRepo = _MockCourseRepo();
  when(() => courseRepo.getStudentCourses()).thenAnswer((_) async => []);
  when(() => courseRepo.getDoctorCourses()).thenAnswer((_) async => []);

  final profileRepo = _MockProfileRepo();
  when(() => profileRepo.getProfile()).thenThrow(Exception('no profile'));

  getIt.registerSingleton<SecureStorageService>(_storage);
  getIt.registerSingleton<AnnounRepo>(annRepo);
  getIt.registerSingleton<ChatRepo>(chatRepo);
  getIt.registerSingleton<CourseRepo>(courseRepo);
  getIt.registerSingleton<ProfileRepo>(profileRepo);
  getIt.registerSingleton<AnnouncementChangeNotifier>(
      AnnouncementChangeNotifier());
  getIt.registerSingleton<AnnouncementWsService>(_FakeAnnouncementWsService());
  getIt.registerSingleton<ChatWebSocketService>(_FakeChatWsService());
  getIt.registerSingleton<VoiceRecorderService>(VoiceRecorderService());
  getIt.registerSingleton<AudioPlayerService>(_MockAudioPlayerService());
}

// ── Widget builder ────────────────────────────────────────────────────────────

Widget _buildSubject(SessionCubit sessionCubit) => testWrap(
      BlocProvider.value(value: sessionCubit, child: const HomeViewBody()),
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  setUp(_fullGetItSetup);

  tearDown(() => getIt.reset());

  SessionCubit makeSession(String typeCode) {
    final cubit = SessionCubit(_storage);
    cubit.initFromAuth(typeCode: typeCode, userId: 1);
    return cubit;
  }

  group('HomeViewBody', () {
    testWidgets('student role shows BottomNavigationBar', (tester) async {
      final session = makeSession('STU');
      addTearDown(session.close);

      await tester.pumpWidget(_buildSubject(session));
      await tester.pump();

      expect(find.byType(HomeBottomNavigationBar), findsOneWidget);

      // AnnounLoadingSkeletonCard index 3 creates a 360ms Future.delayed — pump past it
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('doctor role shows BottomNavigationBar', (tester) async {
      final session = makeSession('DR');
      addTearDown(session.close);

      await tester.pumpWidget(_buildSubject(session));
      await tester.pump();

      expect(find.byType(HomeBottomNavigationBar), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('doctor role on tab 0 shows FloatingActionButton',
        (tester) async {
      final session = makeSession('DR');
      addTearDown(session.close);

      await tester.pumpWidget(_buildSubject(session));
      await tester.pump();

      expect(find.byType(HomeFloatingActionButton), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('admin role has NO BottomNavigationBar', (tester) async {
      final session = makeSession('ADM');
      addTearDown(session.close);

      await tester.pumpWidget(_buildSubject(session));
      await tester.pump();

      expect(find.byType(HomeBottomNavigationBar), findsNothing);

      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('student role starts on first tab (index 0)', (tester) async {
      final session = makeSession('STU');
      addTearDown(session.close);

      await tester.pumpWidget(_buildSubject(session));
      await tester.pump();

      final bnb = tester.widget<HomeBottomNavigationBar>(
        find.byType(HomeBottomNavigationBar),
      );
      expect(bnb.currentIndex, 0);

      await tester.pump(const Duration(milliseconds: 400));
    });
  });
}
