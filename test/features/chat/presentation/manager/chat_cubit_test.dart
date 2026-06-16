import 'dart:async';

import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_ws_events.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/chat_cubit/chat_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockChatRepo extends Mock implements ChatRepo {}

class _MockSecureStorage extends Mock implements SecureStorageService {}

// Hand-crafted fake so we can control the event stream in tests.
class _FakeWsService implements ChatWebSocketService {
  final _ctrl = StreamController<WsEvent>.broadcast();
  bool _connected = true;

  @override
  Stream<WsEvent> get events => _ctrl.stream;

  @override
  bool get isConnected => _connected;

  void setConnected(bool v) => _connected = v;

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

  void emit(WsEvent event) => _ctrl.add(event);
}

ChatUser _user(String id, {String name = 'User'}) =>
    ChatUser(
      id: id,
      name: name,
      role: UserRole.student,
      studentId: 'STU-$id',
    );

ChatConversation _convo(String partnerId,
    {int unread = 0, bool pinned = false, String partnerName = 'User'}) =>
    ChatConversation(
      id: 'conv-$partnerId',
      otherUser: _user(partnerId, name: partnerName),
      unreadCount: unread,
      isPinned: pinned,
    );

ChatMessage _msg(String id,
    {String senderId = '1',
    bool isFromMe = true,
    MessageStatus status = MessageStatus.sent}) =>
    ChatMessage(
      id: id,
      senderId: senderId,
      type: MessageType.text,
      text: 'Message $id',
      timestamp: DateTime(2024, 1, 1),
      status: status,
      isFromMe: isFromMe,
    );

void main() {
  late _MockChatRepo repo;
  late _MockSecureStorage storage;
  late _FakeWsService ws;

  setUp(() {
    repo = _MockChatRepo();
    storage = _MockSecureStorage();
    ws = _FakeWsService();
    when(() => storage.getUserId()).thenAnswer((_) async => 1);
  });

  tearDown(() => ws.dispose());

  group('ChatCubit', () {
    test('initial state is ChatInitial', () {
      expect(ChatCubit(repo, ws, storage).state, isA<ChatInitial>());
    });

    // ── loadConversations ─────────────────────────────────────────────────────

    group('loadConversations', () {
      blocTest<ChatCubit, ChatState>(
        'emits [ChatLoading, ChatLoaded] on success',
        build: () {
          when(() => repo.getConversations())
              .thenAnswer((_) async => [_convo('2'), _convo('3')]);
          return ChatCubit(repo, ws, storage);
        },
        act: (c) => c.loadConversations(),
        expect: () => [
          isA<ChatLoading>(),
          isA<ChatLoaded>()
              .having((s) => s.conversations.length, 'count', 2),
        ],
      );

      blocTest<ChatCubit, ChatState>(
        'emits ChatError on failure',
        build: () {
          when(() => repo.getConversations())
              .thenThrow(Exception('No connection'));
          return ChatCubit(repo, ws, storage);
        },
        act: (c) => c.loadConversations(),
        expect: () => [isA<ChatLoading>(), isA<ChatError>()],
      );

      blocTest<ChatCubit, ChatState>(
        'filters out self conversation (same id as myUserId)',
        build: () {
          when(() => repo.getConversations()).thenAnswer((_) async => [
                _convo('1'), // same as myUserId — should be filtered
                _convo('2'),
              ]);
          return ChatCubit(repo, ws, storage);
        },
        act: (c) => c.loadConversations(),
        expect: () => [
          isA<ChatLoading>(),
          isA<ChatLoaded>()
              .having((s) => s.conversations.length, 'filtered count', 1),
        ],
      );
    });

    // ── openChat ──────────────────────────────────────────────────────────────

    group('openChat', () {
      blocTest<ChatCubit, ChatState>(
        'clears unread count for the opened conversation immediately',
        build: () => ChatCubit(repo, ws, storage),
        seed: () => ChatLoaded(
          conversations: [_convo('2', unread: 5), _convo('3', unread: 2)],
          filtered: [_convo('2', unread: 5), _convo('3', unread: 2)],
        ),
        act: (c) => c.openChat('2'),
        expect: () => [
          isA<ChatLoaded>().having(
            (s) => s.conversations.first.unreadCount,
            'unread cleared',
            0,
          ),
        ],
      );

      blocTest<ChatCubit, ChatState>(
        'does not affect other conversations unread counts',
        build: () => ChatCubit(repo, ws, storage),
        seed: () => ChatLoaded(
          conversations: [_convo('2', unread: 3), _convo('3', unread: 7)],
          filtered: [_convo('2', unread: 3), _convo('3', unread: 7)],
        ),
        act: (c) => c.openChat('2'),
        expect: () => [
          isA<ChatLoaded>().having(
            (s) => s.conversations.last.unreadCount,
            'partner 3 unread unchanged',
            7,
          ),
        ],
      );
    });

    // ── searchConversations ───────────────────────────────────────────────────

    group('searchConversations', () {
      blocTest<ChatCubit, ChatState>(
        'filters by name (case-insensitive)',
        build: () => ChatCubit(repo, ws, storage),
        seed: () => ChatLoaded(
          conversations: [
            _convo('2', partnerName: 'Ahmed Ali'),
            _convo('3', partnerName: 'Sara Mohamed'),
            _convo('4', partnerName: 'Ahmed Khaled'),
          ],
          filtered: [
            _convo('2', partnerName: 'Ahmed Ali'),
            _convo('3', partnerName: 'Sara Mohamed'),
            _convo('4', partnerName: 'Ahmed Khaled'),
          ],
        ),
        act: (c) => c.searchConversations('ahmed'),
        expect: () => [
          isA<ChatLoaded>()
              .having((s) => s.filtered.length, 'filtered count', 2),
        ],
      );

      blocTest<ChatCubit, ChatState>(
        'filters by studentId',
        build: () => ChatCubit(repo, ws, storage),
        seed: () => ChatLoaded(
          conversations: [_convo('2', partnerName: 'User A'), _convo('3')],
          filtered: [_convo('2', partnerName: 'User A'), _convo('3')],
        ),
        act: (c) => c.searchConversations('STU-2'),
        expect: () => [
          isA<ChatLoaded>()
              .having((s) => s.filtered.length, 'by studentId', 1),
        ],
      );

      blocTest<ChatCubit, ChatState>(
        'empty query shows all conversations',
        build: () => ChatCubit(repo, ws, storage),
        seed: () => ChatLoaded(
          conversations: [_convo('2'), _convo('3'), _convo('4')],
          filtered: [_convo('2')], // was filtered
        ),
        act: (c) => c.searchConversations(''),
        expect: () => [
          isA<ChatLoaded>()
              .having((s) => s.filtered.length, 'all shown', 3),
        ],
      );
    });

    // ── syncLastMessage ───────────────────────────────────────────────────────

    group('syncLastMessage', () {
      blocTest<ChatCubit, ChatState>(
        'updates last message for the specified partner',
        build: () => ChatCubit(repo, ws, storage),
        seed: () => ChatLoaded(
          conversations: [_convo('2'), _convo('3')],
          filtered: [_convo('2'), _convo('3')],
        ),
        act: (c) => c.syncLastMessage('2', _msg('42')),
        expect: () => [
          isA<ChatLoaded>().having(
            (s) => s.conversations.first.lastMessage?.id,
            'last message id',
            '42',
          ),
        ],
      );

      blocTest<ChatCubit, ChatState>(
        'does nothing when lastMsg is null',
        build: () => ChatCubit(repo, ws, storage),
        seed: () => ChatLoaded(
          conversations: [_convo('2')],
          filtered: [_convo('2')],
        ),
        act: (c) => c.syncLastMessage('2', null),
        expect: () => [],
      );
    });

    // ── pinConversation (optimistic) ──────────────────────────────────────────

    group('pinConversation', () {
      blocTest<ChatCubit, ChatState>(
        'optimistically moves conversation to top and marks isPinned',
        build: () {
          when(() => repo.pinConversation(any()))
              .thenAnswer((_) async {});
          return ChatCubit(repo, ws, storage);
        },
        seed: () => ChatLoaded(
          conversations: [_convo('2'), _convo('3')],
          filtered: [_convo('2'), _convo('3')],
        ),
        act: (c) => c.pinConversation(_convo('3')),
        expect: () => [
          isA<ChatLoaded>()
              .having((s) => s.conversations.first.otherUser.id, 'pinned first', '3')
              .having((s) => s.conversations.first.isPinned, 'isPinned', true),
        ],
      );
    });

    // ── WS: _updateConversationWithMessage ────────────────────────────────────

    group('WS _updateConversationWithMessage', () {
      test('non-pinned conversation moves to top when new message arrives',
          () async {
        when(() => repo.getConversations()).thenAnswer((_) async => [
              _convo('2'),
              _convo('3'),
              _convo('4'),
            ]);

        final cubit = ChatCubit(repo, ws, storage);
        await cubit.loadConversations();

        // Simulate incoming message from partner 4 (currently last)
        ws.emit(WsMessageReceivedEvent({
          'chat_id': 100,
          'sender_id': 4,
          'receiver_id': 1,
          'content_type': 'text',
          'message': 'Hey!',
          'sent_at': DateTime.now().toIso8601String(),
          'status': 'sent',
          'is_deleted': false,
        }));

        await Future.microtask(() {});

        final loaded = cubit.state as ChatLoaded;
        // Partner 4 should now be at the top (index 0)
        expect(loaded.conversations.first.otherUser.id, '4');

        cubit.close();
      });

      test('pinned conversation stays in its pinned position', () async {
        when(() => repo.getConversations()).thenAnswer((_) async => [
              _convo('2', pinned: true),
              _convo('3'),
            ]);

        final cubit = ChatCubit(repo, ws, storage);
        await cubit.loadConversations();

        // New message from non-pinned partner 3
        ws.emit(WsMessageReceivedEvent({
          'chat_id': 101,
          'sender_id': 3,
          'receiver_id': 1,
          'content_type': 'text',
          'message': 'Hi',
          'sent_at': DateTime.now().toIso8601String(),
          'status': 'sent',
          'is_deleted': false,
        }));

        await Future.microtask(() {});

        final loaded = cubit.state as ChatLoaded;
        // Pinned partner 2 must still be first
        expect(loaded.conversations.first.otherUser.id, '2');
        expect(loaded.conversations.first.isPinned, true);

        cubit.close();
      });

      test('increments unread only when chat is not open', () async {
        when(() => repo.getConversations()).thenAnswer((_) async => [
              _convo('2', unread: 0),
            ]);

        final cubit = ChatCubit(repo, ws, storage);
        await cubit.loadConversations();

        // Simulate opening the chat with partner 2
        cubit.openChat('2');

        // Receive message from partner 2 (chat is open — should NOT increment)
        ws.emit(WsMessageReceivedEvent({
          'chat_id': 200,
          'sender_id': 2,
          'receiver_id': 1,
          'content_type': 'text',
          'message': 'Hello',
          'sent_at': DateTime.now().toIso8601String(),
          'status': 'sent',
          'is_deleted': false,
        }));

        await Future.microtask(() {});

        final loaded = cubit.state as ChatLoaded;
        expect(loaded.conversations.first.unreadCount, 0);

        cubit.close();
      });

      test('increments unread when message arrives and chat is closed',
          () async {
        when(() => repo.getConversations()).thenAnswer((_) async => [
              _convo('2', unread: 0),
            ]);

        final cubit = ChatCubit(repo, ws, storage);
        await cubit.loadConversations();

        ws.emit(WsMessageReceivedEvent({
          'chat_id': 201,
          'sender_id': 2,
          'receiver_id': 1,
          'content_type': 'text',
          'message': 'Hi there',
          'sent_at': DateTime.now().toIso8601String(),
          'status': 'sent',
          'is_deleted': false,
        }));

        await Future.microtask(() {});

        final loaded = cubit.state as ChatLoaded;
        expect(loaded.conversations.first.unreadCount, 1);

        cubit.close();
      });
    });

    // ── WS: _onLastMessageEdited / _onLastMessageDeleted ──────────────────────

    group('WS last message sync', () {
      test('_onLastMessageEdited updates last message text', () async {
        final lastMsg = _msg('50', senderId: '2', isFromMe: false);
        when(() => repo.getConversations()).thenAnswer((_) async => [
              ChatConversation(
                id: 'conv-2',
                otherUser: _user('2'),
                lastMessage: lastMsg,
              ),
            ]);

        final cubit = ChatCubit(repo, ws, storage);
        await cubit.loadConversations();

        ws.emit(WsMessageEditedEvent(
            chatId: 50, newText: 'Edited text', editedAt: ''));

        await Future.microtask(() {});

        final loaded = cubit.state as ChatLoaded;
        expect(loaded.conversations.first.lastMessage?.text, 'Edited text');

        cubit.close();
      });

      test('_onLastMessageDeleted marks last message as deleted', () async {
        final lastMsg = _msg('51', senderId: '2', isFromMe: false);
        when(() => repo.getConversations()).thenAnswer((_) async => [
              ChatConversation(
                id: 'conv-2',
                otherUser: _user('2'),
                lastMessage: lastMsg,
                unreadCount: 1,
              ),
            ]);

        final cubit = ChatCubit(repo, ws, storage);
        await cubit.loadConversations();

        ws.emit(WsMessageDeletedEvent(51));

        await Future.microtask(() {});

        final loaded = cubit.state as ChatLoaded;
        expect(loaded.conversations.first.lastMessage?.isDeleted, true);
        expect(loaded.conversations.first.unreadCount, 0);

        cubit.close();
      });
    });
  });
}
