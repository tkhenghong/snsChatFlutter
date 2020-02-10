// system message or normal message, sticker, gifs, emojis, video, recording, photos,
class Message {
  String id;
  String conversationId;

//  String recipientId; // Recipient
  // Sender
  String senderId; // Use UserContactId
  String senderName;
  String senderMobileNo;

  // Receiver
  String receiverId; // Use UserContactId
  String receiverName;
  String receiverMobileNo;

  String type;
  String status; // Sent, received, unread, read
  String messageContent;
  String multimediaId; // Multimedia
  int timestamp;

  Message(
      {this.id,
      this.conversationId,
      this.senderId,
      this.senderName,
      this.senderMobileNo,
      this.receiverId,
      this.receiverName,
      this.receiverMobileNo,
      this.type,
      this.status,
      this.messageContent,
      this.multimediaId,
      this.timestamp});

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        conversationId = json['conversationId'],
        senderId = json['senderId'],
        senderName = json['senderName'],
        senderMobileNo = json['senderMobileNo'],
        receiverId = json['receiverId'],
        receiverName = json['receiverName'],
        receiverMobileNo = json['receiverMobileNo'],
        type = json['type'],
        status = json['status'],
        messageContent = json['messageContent'],
        multimediaId = json['multimediaId'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'senderName': senderName,
        'senderMobileNo': senderMobileNo,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'receiverMobileNo': receiverMobileNo,
        'type': type,
        'status': status,
        'messageContent': messageContent,
        'multimediaId': multimediaId,
        'timestamp': timestamp,
      };
}