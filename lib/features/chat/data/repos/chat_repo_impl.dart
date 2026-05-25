import 'package:ai_eru_tawasol/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/repos/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  const ChatRepoImpl(this._datasource);

  final ChatRemoteDatasource _datasource;

  @override
  Future<List<ChatConversation>> getConversations() =>
      _datasource.getConversations();

  @override
  Future<List<ChatMessage>> getMessages(String otherUserId) =>
      _datasource.getMessages(otherUserId);

  @override
  Future<List<ChatUser>> searchUsers(String q) =>
      _datasource.searchUsers(q);

  @override
  Future<void> markSeen(String otherUserId) =>
      _datasource.markSeen(otherUserId);

  @override
  Future<ChatMessage> editMessage(String chatId, String newText) =>
      _datasource.editMessage(int.parse(chatId), newText);

  @override
  Future<void> deleteMessage(String chatId) =>
      _datasource.deleteMessage(int.parse(chatId));

  @override
  Future<void> pinConversation(String partnerId) =>
      _datasource.pinConversation(int.parse(partnerId));

  @override
  Future<void> unpinConversation(String partnerId) =>
      _datasource.unpinConversation(int.parse(partnerId));
}
