import 'dart:async';

import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_ws_events.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/chat_websocket_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/manager/private_chat_cubit/private_chat_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockChatRepo extends Mock implements ChatRepo {}

class _MockSecureStorage extends Mock implements SecureStorageService {}

// Fake WS service so the event stream is fully controllable in tests.
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

// ── Test data helpers ─────────────────────────────────────────────────────────

const _myUserId = 1;
const _partnerUserId = 2;

ChatMessage _myMsg(String id,
    {String text = 'Hello',
    MessageStatus status = MessageStatus.sent,
    bool isDeleted = false}) =>
    ChatMessage(
      id: id,
      senderId: _myUserId.toString(),
      type: MessageType.text,
      text: text,
      timestamp: DateTime(2024, 1, 1, 12, 0),
      status: status,
      isFromMe: true,
      isDeleted: isDeleted,
    );

ChatMessage _partnerMsg(String id, {String text = 'Hi'}) => ChatMessage(
      id: id,
      senderId: _partnerUserId.toString(),
      type: MessageType.text,
      text: text,
      timestamp: DateTime(2024, 1, 1, 12, 0),
      status: MessageStatus.sent,
      isFromMe: false,
    );

Map<String, dynamic> _sentPayload(int chatId, {String text = 'Hello'}) => {
      'chat_id': chatId,
      'sender_id': _myUserId,
      'receiver_id': _partnerUserId,
      'content_type': 'text',
      'message': text,
      'sent_at': DateTime(2024, 1, 1, 12, 1).toIso8601String(),
      'status': 'sent',
      'is_deleted': false,
    };

Map<String, dynamic> _receivedPayload(int chatId, {String text = 'Incoming'}) =>
    {
      'chat_id': chatId,
      'sender_id': _partnerUserId,
      'receiver_id': _myUserId,
      'content_type': 'text',
      'message': text,
      'sent_at': DateTime(2024, 1, 1, 12, 2).toIso8601String(),
      'status': 'sent',
      'is_deleted': false,
    };

// ── Convenience: loads messages and returns the cubit ─────────────────────────

Future<PrivateChatCubit> _loadedCubit({
  required _MockChatRepo repo,
  required _FakeWsService ws,
  required _MockSecureStorage storage,
  List<ChatMessage> messages = const [],
}) async {
  when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
  when(() => repo.getMessages(any())).thenAnswer((_) async => messages);

  final cubit = PrivateChatCubit(repo, ws, storage);
  await cubit.loadMessages(_partnerUserId.toString());
  expect(cubit.state, isA<PrivateChatLoaded>());
  return cubit;
}

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  late _MockChatRepo repo;
  late _MockSecureStorage storage;
  late _FakeWsService ws;

  setUp(() {
    repo = _MockChatRepo();
    storage = _MockSecureStorage();
    ws = _FakeWsService();
  });

  tearDown(() => ws.dispose());

  group('PrivateChatCubit', () {
    test('initial state is PrivateChatInitial', () {
      expect(
        PrivateChatCubit(repo, ws, storage).state,
        isA<PrivateChatInitial>(),
      );
    });

    // ── loadMessages ──────────────────────────────────────────────────────────

    group('loadMessages', () {
      blocTest<PrivateChatCubit, PrivateChatState>(
        'emits [PrivateChatLoading, PrivateChatLoaded] on success',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenAnswer((_) async => [_myMsg('1'), _partnerMsg('2')]);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) => c.loadMessages('2'),
        expect: () => [
          isA<PrivateChatLoading>(),
          isA<PrivateChatLoaded>()
              .having((s) => s.messages.length, 'count', 2),
        ],
      );

      blocTest<PrivateChatCubit, PrivateChatState>(
        'emits PrivateChatError when userId is invalid',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => null);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) => c.loadMessages('2'),
        expect: () => [isA<PrivateChatError>()],
      );

      blocTest<PrivateChatCubit, PrivateChatState>(
        'emits PrivateChatError on repo failure',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenThrow(Exception('Failed to load'));
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) => c.loadMessages('2'),
        expect: () => [
          isA<PrivateChatLoading>(),
          isA<PrivateChatError>(),
        ],
      );
    });

    // ── FIFO pending queue: _onMessageConfirmed ───────────────────────────────

    group('FIFO pending queue', () {
      test('WsMessageSentEvent replaces the oldest pending temp message', () async {
        final cubit = await _loadedCubit(repo: repo, ws: ws, storage: storage);

        // Send a text message — adds temp to queue and state
        ws.setConnected(true);
        await cubit.sendTextMessage('Hello');

        final afterSend = cubit.state as PrivateChatLoaded;
        expect(afterSend.messages.length, 1);
        expect(afterSend.messages.first.id, startsWith('temp_'));

        // Server confirms the message
        ws.emit(WsMessageSentEvent(_sentPayload(42)));
        await Future.microtask(() {});

        final afterConfirm = cubit.state as PrivateChatLoaded;
        expect(afterConfirm.messages.length, 1);
        expect(afterConfirm.messages.first.id, '42');
        expect(afterConfirm.messages.first.status, MessageStatus.sent);

        cubit.close();
      });

      test('FIFO order: two messages are confirmed in send order', () async {
        final cubit = await _loadedCubit(repo: repo, ws: ws, storage: storage);
        ws.setConnected(true);

        // Send two messages quickly
        await cubit.sendTextMessage('First');
        await cubit.sendTextMessage('Second');

        final afterSend = cubit.state as PrivateChatLoaded;
        expect(afterSend.messages.length, 2);
        final tempId0 = afterSend.messages[0].id;
        final tempId1 = afterSend.messages[1].id;
        expect(tempId0, startsWith('temp_'));
        expect(tempId1, startsWith('temp_'));

        // First confirmation → should replace tempId0 (FIFO)
        ws.emit(WsMessageSentEvent(_sentPayload(100, text: 'First')));
        await Future.microtask(() {});

        final after1 = cubit.state as PrivateChatLoaded;
        expect(after1.messages[0].id, '100');
        expect(after1.messages[1].id, tempId1); // still pending

        // Second confirmation → should replace tempId1
        ws.emit(WsMessageSentEvent(_sentPayload(101, text: 'Second')));
        await Future.microtask(() {});

        final after2 = cubit.state as PrivateChatLoaded;
        expect(after2.messages[0].id, '100');
        expect(after2.messages[1].id, '101');

        cubit.close();
      });

      test('duplicate confirmed id is ignored (dedup check)', () async {
        final initial = [_myMsg('99')]; // already confirmed in list
        final cubit =
            await _loadedCubit(repo: repo, ws: ws, storage: storage, messages: initial);
        ws.setConnected(true);

        // WS echo for a message already in the list
        ws.emit(WsMessageSentEvent(_sentPayload(99)));
        await Future.microtask(() {});

        // Should still be 1 message, not 2
        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.length, 1);
        expect(state.messages.first.id, '99');

        cubit.close();
      });

      test('no matching temp: confirmed message is appended', () async {
        final cubit = await _loadedCubit(repo: repo, ws: ws, storage: storage);
        ws.setConnected(true);

        // Fire confirmation without a prior send (no temp in queue)
        ws.emit(WsMessageSentEvent(_sentPayload(200)));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.length, 1);
        expect(state.messages.first.id, '200');

        cubit.close();
      });
    });

    // ── _onIncomingMessage ────────────────────────────────────────────────────

    group('incoming message from partner', () {
      test('adds message to the list', () async {
        final cubit = await _loadedCubit(repo: repo, ws: ws, storage: storage);

        ws.emit(WsMessageReceivedEvent(_receivedPayload(300)));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.length, 1);
        expect(state.messages.first.id, '300');
        expect(state.messages.first.isFromMe, false);

        cubit.close();
      });

      test('ignores duplicate incoming message (same id)', () async {
        final cubit = await _loadedCubit(
          repo: repo, ws: ws, storage: storage,
          messages: [_partnerMsg('300')],
        );

        ws.emit(WsMessageReceivedEvent(_receivedPayload(300)));
        await Future.microtask(() {});

        // Must stay at 1, not add a second copy
        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.length, 1);

        cubit.close();
      });

      test('ignores messages from other senders (not the partner)', () async {
        final cubit = await _loadedCubit(repo: repo, ws: ws, storage: storage);

        // Message from user 99 (not our partner 2)
        ws.emit(WsMessageReceivedEvent({
          'chat_id': 400,
          'sender_id': 99,
          'receiver_id': _myUserId,
          'content_type': 'text',
          'message': 'Spam',
          'sent_at': DateTime.now().toIso8601String(),
          'status': 'sent',
          'is_deleted': false,
        }));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages, isEmpty);

        cubit.close();
      });
    });

    // ── _onAllMessagesSeen ────────────────────────────────────────────────────

    group('_onAllMessagesSeen', () {
      test('marks all isFromMe messages as seen', () async {
        final cubit = await _loadedCubit(
          repo: repo, ws: ws, storage: storage,
          messages: [
            _myMsg('1', status: MessageStatus.delivered),
            _partnerMsg('2'),
          ],
        );

        ws.emit(WsSeenEvent(_partnerUserId));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages[0].status, MessageStatus.seen);
        // Partner's message status is untouched
        expect(state.messages[1].status, MessageStatus.sent);

        cubit.close();
      });

      test('ignores seen event from unknown user', () async {
        final cubit = await _loadedCubit(
          repo: repo, ws: ws, storage: storage,
          messages: [_myMsg('1', status: MessageStatus.delivered)],
        );

        ws.emit(WsSeenEvent(99)); // wrong user
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.first.status, MessageStatus.delivered);

        cubit.close();
      });
    });

    // ── _onMessagesDelivered ──────────────────────────────────────────────────

    group('_onMessagesDelivered', () {
      test('upgrades only sending-status messages to delivered', () async {
        final cubit = await _loadedCubit(
          repo: repo, ws: ws, storage: storage,
          messages: [
            _myMsg('1', status: MessageStatus.sending),
            _myMsg('2', status: MessageStatus.sent), // already past sending
          ],
        );

        ws.emit(WsDeliveredEvent(_partnerUserId));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages[0].status, MessageStatus.delivered);
        expect(state.messages[1].status, MessageStatus.sent); // unchanged

        cubit.close();
      });
    });

    // ── _onMessageEdited ──────────────────────────────────────────────────────

    group('_onMessageEdited (incoming from partner)', () {
      test('updates text and editedAt for matching message id', () async {
        final editedAt = DateTime(2024, 1, 1, 13, 0);
        final cubit = await _loadedCubit(
          repo: repo, ws: ws, storage: storage,
          messages: [_partnerMsg('50', text: 'Original')],
        );

        ws.emit(WsMessageEditedEvent(
          chatId: 50,
          newText: 'Edited',
          editedAt: editedAt.toIso8601String(),
        ));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.first.text, 'Edited');
        expect(state.messages.first.editedAt, isNotNull);

        cubit.close();
      });
    });

    // ── _onMessageDeleted ─────────────────────────────────────────────────────

    group('_onMessageDeleted (incoming from partner)', () {
      test('marks message as deleted without removing it from the list', () async {
        final cubit = await _loadedCubit(
          repo: repo, ws: ws, storage: storage,
          messages: [_partnerMsg('60'), _partnerMsg('61')],
        );

        ws.emit(WsMessageDeletedEvent(60));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.length, 2);
        expect(state.messages.first.isDeleted, true);
        expect(state.messages.last.isDeleted, false);

        cubit.close();
      });
    });

    // ── _onSendError ──────────────────────────────────────────────────────────

    group('_onSendError', () {
      test('removes all sending messages and sets sendError', () async {
        final cubit = await _loadedCubit(
          repo: repo, ws: ws, storage: storage,
          messages: [
            _myMsg('1', status: MessageStatus.sent),
            _myMsg('temp_999', status: MessageStatus.sending),
          ],
        );

        ws.emit(WsErrorEvent('Message too long'));
        await Future.microtask(() {});

        final state = cubit.state as PrivateChatLoaded;
        expect(state.messages.length, 1); // sending message removed
        expect(state.messages.first.id, '1');
        expect(state.sendError, 'Message too long');

        cubit.close();
      });
    });

    // ── editMessage ───────────────────────────────────────────────────────────

    group('editMessage', () {
      blocTest<PrivateChatCubit, PrivateChatState>(
        'optimistically updates text then confirms from API',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenAnswer((_) async => [_myMsg('10', text: 'Original')]);
          when(() => repo.editMessage(any(), any()))
              .thenAnswer((_) async => _myMsg('10', text: 'Edited'));
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          await c.editMessage('10', 'Edited');
        },
        // We check the final state, not every intermediate emit
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.messages.first.text, 'Edited');
        },
      );

      blocTest<PrivateChatCubit, PrivateChatState>(
        'rolls back to original state when API fails',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenAnswer((_) async => [_myMsg('10', text: 'Original')]);
          when(() => repo.editMessage(any(), any()))
              .thenThrow(Exception('Edit failed'));
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          await c.editMessage('10', 'Attempted Edit');
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.messages.first.text, 'Original');
        },
      );
    });

    // ── deleteMessage ─────────────────────────────────────────────────────────

    group('deleteMessage', () {
      blocTest<PrivateChatCubit, PrivateChatState>(
        'optimistically marks isDeleted=true',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenAnswer((_) async => [_myMsg('20')]);
          when(() => repo.deleteMessage(any())).thenAnswer((_) async {});
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          await c.deleteMessage('20');
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.messages.first.isDeleted, true);
        },
      );

      blocTest<PrivateChatCubit, PrivateChatState>(
        'rolls back to original when API fails',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenAnswer((_) async => [_myMsg('20')]);
          when(() => repo.deleteMessage(any()))
              .thenThrow(Exception('Delete failed'));
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          await c.deleteMessage('20');
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.messages.first.isDeleted, false);
        },
      );
    });

    // ── reply / replyTo ───────────────────────────────────────────────────────

    group('setReplyTo', () {
      blocTest<PrivateChatCubit, PrivateChatState>(
        'sets replyingTo on the state',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any())).thenAnswer((_) async => []);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          c.setReplyTo(_partnerMsg('5'));
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.replyingTo?.id, '5');
        },
      );

      blocTest<PrivateChatCubit, PrivateChatState>(
        'clears replyingTo when null is passed',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any())).thenAnswer((_) async => []);
          return PrivateChatCubit(repo, ws, storage);
        },
        seed: () => PrivateChatLoaded(
          messages: const [],
          replyingTo: _partnerMsg('5'),
        ),
        act: (c) async {
          // Seed doesn't set internal fields, so we must load first
          await c.loadMessages('2');
          c.setReplyTo(_partnerMsg('5'));
          c.setReplyTo(null);
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.replyingTo, isNull);
        },
      );
    });

    // ── search ────────────────────────────────────────────────────────────────

    group('searchMessages', () {
      blocTest<PrivateChatCubit, PrivateChatState>(
        'finds messages matching query in text',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any())).thenAnswer((_) async => [
                _myMsg('1', text: 'Hello World'),
                _myMsg('2', text: 'Goodbye'),
                _myMsg('3', text: 'Hello again'),
              ]);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          c.toggleSearch();
          c.searchMessages('hello');
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.searchResults.length, 2);
          expect(state.searchResults, containsAll(['1', '3']));
          // index starts at newest match
          expect(state.searchResultIndex, 1);
        },
      );

      blocTest<PrivateChatCubit, PrivateChatState>(
        'empty query returns no results',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenAnswer((_) async => [_myMsg('1', text: 'Hello')]);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          c.toggleSearch();
          c.searchMessages('');
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.searchResults, isEmpty);
        },
      );
    });

    group('navigateSearchUp / navigateSearchDown', () {
      blocTest<PrivateChatCubit, PrivateChatState>(
        'navigateSearchUp increments index (clamped)',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any())).thenAnswer((_) async => [
                _myMsg('1', text: 'Hi'),
                _myMsg('2', text: 'Hi'),
                _myMsg('3', text: 'Hi'),
              ]);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          c.toggleSearch();
          c.searchMessages('hi');
          // index starts at 2 (newest)
          c.navigateSearchDown(); // → 1
          c.navigateSearchDown(); // → 0
          c.navigateSearchDown(); // clamped, stays 0
          c.navigateSearchUp();   // → 1
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.searchResultIndex, 1);
        },
      );
    });

    group('toggleSearch', () {
      blocTest<PrivateChatCubit, PrivateChatState>(
        'opens search mode',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any())).thenAnswer((_) async => []);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          c.toggleSearch();
        },
        verify: (c) {
          expect((c.state as PrivateChatLoaded).isSearching, true);
        },
      );

      blocTest<PrivateChatCubit, PrivateChatState>(
        'closes search and clears query/results',
        build: () {
          when(() => storage.getUserId()).thenAnswer((_) async => _myUserId);
          when(() => repo.getMessages(any()))
              .thenAnswer((_) async => [_myMsg('1', text: 'Hello')]);
          return PrivateChatCubit(repo, ws, storage);
        },
        act: (c) async {
          await c.loadMessages('2');
          c.toggleSearch();
          c.searchMessages('hello');
          c.toggleSearch(); // close
        },
        verify: (c) {
          final state = c.state as PrivateChatLoaded;
          expect(state.isSearching, false);
          expect(state.searchResults, isEmpty);
          expect(state.searchQuery, '');
        },
      );
    });
  });
}
