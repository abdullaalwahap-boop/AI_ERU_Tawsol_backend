import 'package:ai_eru_tawasol/features/chat/data/models/message_status.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/message_type.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final MessageType type;
  final String? text;
  final String? fileUrl;
  final String? fileName;
  final double? fileSizeMB;
  final Duration? voiceDuration;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isFromMe;
  final bool isDeleted;
  final DateTime? editedAt;
  final String? replyToId;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.type,
    this.text,
    this.fileUrl,
    this.fileName,
    this.fileSizeMB,
    this.voiceDuration,
    required this.timestamp,
    required this.status,
    required this.isFromMe,
    this.isDeleted = false,
    this.editedAt,
    this.replyToId,
  });

  bool get canEdit =>
      isFromMe &&
      type == MessageType.text &&
      !isDeleted &&
      DateTime.now().difference(timestamp).inMinutes < 15;

  bool get canDelete =>
      isFromMe &&
      !isDeleted &&
      DateTime.now().difference(timestamp).inMinutes < 15;

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {required int myUserId}) {
    final senderId = json['sender_id'] as int;
    final sizeBytes = json['file_size_bytes'] as int?;
    final voiceSecs = json['voice_duration_seconds'] as int?;
    return ChatMessage(
      id: (json['chat_id'] as int).toString(),
      senderId: senderId.toString(),
      type: MessageTypeExt.fromString(
          json['content_type'] as String? ?? 'text'),
      text: json['message'] as String?,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSizeMB: sizeBytes != null ? sizeBytes / (1024 * 1024) : null,
      voiceDuration:
          voiceSecs != null ? Duration(seconds: voiceSecs) : null,
      timestamp: DateTime.parse(json['sent_at'] as String),
      status: MessageStatusExt.fromString(
          json['status'] as String? ?? 'sent'),
      isFromMe: senderId == myUserId,
      isDeleted: json['is_deleted'] as bool? ?? false,
      editedAt: json['edited_at'] != null
          ? DateTime.tryParse(json['edited_at'] as String)
          : null,
      replyToId: (json['reply_to_id'] as int?)?.toString(),
    );
  }

  ChatMessage copyWith({
    MessageStatus? status,
    String? text,
    bool? isDeleted,
    DateTime? editedAt,
    String? fileUrl,
    String? fileName,
    double? fileSizeMB,
    Duration? voiceDuration,
    String? replyToId,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      type: type,
      text: text ?? this.text,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSizeMB: fileSizeMB ?? this.fileSizeMB,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      timestamp: timestamp,
      status: status ?? this.status,
      isFromMe: isFromMe,
      isDeleted: isDeleted ?? this.isDeleted,
      editedAt: editedAt ?? this.editedAt,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}
