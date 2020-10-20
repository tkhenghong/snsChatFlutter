enum ChatMessageStatus { Sending, Sent, Received, Read }

extension ChatMessageStatusUtil on ChatMessageStatus {
  String get name {
    switch (this) {
      case ChatMessageStatus.Sending:
        return 'Sending';
      case ChatMessageStatus.Sent:
        return 'Sent';
      case ChatMessageStatus.Received:
        return 'Received';
      case ChatMessageStatus.Read:
        return 'Read';
      default:
        return null;
    }
  }

  static ChatMessageStatus getByName(String name) {
    switch (name) {
      case 'Sending':
        return ChatMessageStatus.Sending;
      case 'Sent':
        return ChatMessageStatus.Sent;
      case 'Received':
        return ChatMessageStatus.Received;
      case 'Read':
        return ChatMessageStatus.Read;
      default:
        return null;
    }
  }
}
