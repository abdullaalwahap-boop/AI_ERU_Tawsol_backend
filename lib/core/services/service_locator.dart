import 'package:ai_eru_tawasol/core/network/dio_client.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo_impl.dart';
import 'package:ai_eru_tawasol/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo_impl.dart';
import 'package:ai_eru_tawasol/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo_impl.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/audio_player_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/voice_recorder_service.dart';
import 'package:ai_eru_tawasol/features/course/data/datasources/course_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo_impl.dart';
import 'package:ai_eru_tawasol/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ─── Secure Storage ───────────────────────────────────────────────────────────
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final storageService = SecureStorageService(secureStorage);
  getIt.registerSingleton<SecureStorageService>(storageService);

  // ─── Network ──────────────────────────────────────────────────────────────────
  final dioClient = DioClient(storageService);
  getIt.registerSingleton<DioClient>(dioClient);

  // ─── Auth ─────────────────────────────────────────────────────────────────────
  final authDatasource = AuthRemoteDatasource(
    dio: dioClient.dio,
    storage: storageService,
  );
  getIt.registerSingleton<AuthRemoteDatasource>(authDatasource);
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(authDatasource));

  // ─── Profile ──────────────────────────────────────────────────────────────────
  final profileDatasource = ProfileRemoteDatasource(dioClient.dio);
  getIt.registerSingleton<ProfileRemoteDatasource>(profileDatasource);
  getIt.registerSingleton<ProfileRepo>(ProfileRepoImpl(profileDatasource));

  // ─── Session ──────────────────────────────────────────────────────────────────
  getIt.registerSingleton<SessionCubit>(SessionCubit(storageService));

  // ─── Course ───────────────────────────────────────────────────────────────────
  final courseDatasource = CourseRemoteDatasource(
    dio: dioClient.dio,
    storage: storageService,
  );
  getIt.registerSingleton<CourseRemoteDatasource>(courseDatasource);
  getIt.registerSingleton<CourseRepo>(CourseRepoImpl(courseDatasource));

  // ─── Chat ─────────────────────────────────────────────────────────────────────
  final chatDatasource = ChatRemoteDatasource(
    dio: dioClient.dio,
    storage: storageService,
  );
  getIt.registerSingleton<ChatRemoteDatasource>(chatDatasource);
  getIt.registerSingleton<ChatRepo>(ChatRepoImpl(chatDatasource));
  getIt.registerSingleton<ChatWebSocketService>(
      ChatWebSocketService(storageService));
  getIt.registerSingleton<VoiceRecorderService>(VoiceRecorderService());
  getIt.registerSingleton<AudioPlayerService>(AudioPlayerService());

  // ─── Other Features ───────────────────────────────────────────────────────────
  getIt.registerSingleton<AnnounRepoImpl>(AnnounRepoImpl());
}
