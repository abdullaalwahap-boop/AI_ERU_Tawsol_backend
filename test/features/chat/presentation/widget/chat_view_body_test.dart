import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/chat_list/chat_view_body.dart';
import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/getit_test_setup.dart';
import '../../../../helpers/test_app_wrapper.dart';

class _MockChatRepo extends Mock implements ChatRepo {}

class _MockSecureStorage extends Mock implements SecureStorageService {}

class _MockChatWsService extends Mock implements ChatWebSocketService {}

ChatUser _user(String id) => ChatUser(
      id: id,
      name: 'User $id',
      role: UserRole.student,
      studentId: 'STU-$id',
    );

ChatConversation _convo(String id) => ChatConversation(
      id: 'conv-$id',
      otherUser: _user(id),
    );

Widget _buildSubject(ChatCubit cubit) => testWrap(
      BlocProvider.value(value: cubit, child: const ChatViewBody()),
    );

void main() {
  late _MockChatRepo repo;
  late _MockSecureStorage storage;
  late _MockChatWsService ws;
  late ChatCubit cubit;

  setUp(() {
    repo = _MockChatRepo();
    storage = _MockSecureStorage();
    ws = _MockChatWsService();

    when(() => storage.getUserId()).thenAnswer((_) async => 1);
    when(() => ws.isConnected).thenReturn(false);
    when(() => ws.events).thenAnswer((_) => const Stream.empty());
    when(() => ws.ensureConnected()).thenAnswer((_) async {});

    cubit = ChatCubit(repo, ws, storage);
    setupTestGetIt();
  });

  tearDown(() {
    cubit.close();
    tearDownTestGetIt();
  });

  group('ChatViewBody', () {
    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      cubit.emit(ChatLoading());

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when state is ChatError', (tester) async {
      cubit.emit(ChatError('Connection failed'));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('Connection failed'), findsOneWidget);
    });

    testWidgets('shows conversation list when loaded with conversations',
        (tester) async {
      final convos = [_convo('2'), _convo('3')];
      cubit.emit(ChatLoaded(conversations: convos, filtered: convos));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('User 2'), findsOneWidget);
      expect(find.text('User 3'), findsOneWidget);
    });

    testWidgets('shows FAB when state is ChatLoaded', (tester) async {
      final convos = [_convo('2')];
      cubit.emit(ChatLoaded(conversations: convos, filtered: convos));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when ChatInitial',
        (tester) async {
      // ChatInitial is the initial state
      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
