enum MessageStatus { sending, sent, delivered, seen }

extension MessageStatusExt on MessageStatus {
  static MessageStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'delivered':
        return MessageStatus.delivered;
      case 'seen':
        return MessageStatus.seen;
      default:
        return MessageStatus.sent;
    }
  }
}
