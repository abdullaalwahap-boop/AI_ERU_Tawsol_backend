import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/private_chat_body.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/input/chat_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/getit_test_setup.dart';
import '../../../../helpers/test_app_wrapper.dart';

class _MockChatRepo extends Mock implements ChatRepo {}

class _MockSecureStorage extends Mock implements SecureStorageService {}

class _MockChatWsService extends Mock implements ChatWebSocketService {}

ChatUser _user(String id, {String name = 'Partner'}) => ChatUser(
      id: id,
      name: name,
      role: UserRole.student,
      studentId: 'STU-$id',
    );

ChatConversation _convo(String partnerId) => ChatConversation(
      id: 'conv-$partnerId',
      otherUser: _user(partnerId, name: 'Test Partner'),
    );

ChatMessage _msg(String id, {bool isFromMe = false}) => ChatMessage(
      id: id,
      senderId: isFromMe ? '1' : '2',
      type: MessageType.text,
      text: 'Message $id',
      timestamp: DateTime(2024, 1, 1),
      status: MessageStatus.sent,
      isFromMe: isFromMe,
    );

Widget _buildSubject(PrivateChatCubit cubit) => testWrap(
      Scaffold(
        body: BlocProvider.value(
          value: cubit,
          child: PrivateChatBody(conversation: _convo('2')),
        ),
      ),
    );

void main() {
  late _MockChatRepo repo;
  late _MockSecureStorage storage;
  late _MockChatWsService ws;
  late PrivateChatCubit cubit;

  setUp(() {
    repo = _MockChatRepo();
    storage = _MockSecureStorage();
    ws = _MockChatWsService();

    when(() => storage.getUserId()).thenAnswer((_) async => 1);
    when(() => ws.isConnected).thenReturn(false);
    when(() => ws.events).thenAnswer((_) => const Stream.empty());
    when(() => ws.ensureConnected()).thenAnswer((_) async {});
    when(() => ws.sendSeen(any())).thenReturn(null);

    cubit = PrivateChatCubit(repo, ws, storage);
    setupTestGetIt(); // registers VoiceRecorderService for ChatInputBar
  });

  tearDown(() {
    cubit.close();
    tearDownTestGetIt();
  });

  group('PrivateChatBody', () {
    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      cubit.emit(PrivateChatLoading());

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows message list when loaded with messages', (tester) async {
      cubit.emit(PrivateChatLoaded(
        messages: [
          _msg('1', isFromMe: false),
          _msg('2', isFromMe: true),
        ],
      ));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('Message 1'), findsOneWidget);
      expect(find.text('Message 2'), findsOneWidget);
    });

    testWidgets('renders ChatInputBar in loaded state', (tester) async {
      cubit.emit(const PrivateChatLoaded(messages: []));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byType(ChatInputBar), findsOneWidget);
    });

    testWidgets('input bar has a text field for message input', (tester) async {
      cubit.emit(const PrivateChatLoaded(messages: []));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('no messages shown when loaded with empty list', (tester) async {
      cubit.emit(const PrivateChatLoaded(messages: []));

      await tester.pumpWidget(_buildSubject(cubit));
      await tester.pump();

      expect(find.text('Message 1'), findsNothing);
    });
  });
}
