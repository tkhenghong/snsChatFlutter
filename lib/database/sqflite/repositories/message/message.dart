import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

//part 'package:snschat_flutter/database/sqflite/repositories/message/message.jorm.dart';

// system message or normal message, sticker, gifs, emojis, video, recording, photos,
class Message {
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
      this.message,
      this.multimediaId});

  Message.make(this.id, this.conversationId, this.senderId, this.senderName, this.senderMobileNo, this.receiverId, this.receiverName,
      this.receiverMobileNo, this.type, this.status, this.message, this.multimediaId);

  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String conversationId;

  // Remove recipient object, too complicated into db and state
//  @Column(isNullable: true)
//  String recipientId; // Recipient object

  // Sender
  @Column(isNullable: true)
  String senderId;

  @Column(isNullable: true)
  String senderName;

  @Column(isNullable: true)
  String senderMobileNo;

  // Receiver
  @Column(isNullable: true)
  String receiverId;

  @Column(isNullable: true)
  String receiverName;

  @Column(isNullable: true)
  String receiverMobileNo;

  @Column(isNullable: true)
  String type;

  @Column(isNullable: true)
  String status; // Sent, received, unread, read

  @Column(isNullable: true)
  String message;

  // TODO: Build table relationships
  @Column(isNullable: true)
  String multimediaId;

  @override
  String toString() {
    return 'Message{id: $id, conversationId: $conversationId, senderId: $senderId, senderName: $senderName, senderMobileNo: $senderMobileNo, receiverId: $receiverId, receiverName: $receiverName, receiverMobileNo: $receiverMobileNo, type: $type, status: $status, message: $message, multimediaId: $multimediaId}';
  } // Multimedia object

}

@GenBean()
//class MessageBean extends Bean<Message> with _MessageBean {
class MessageBean extends Bean<Message> {
  MessageBean(Adapter adapter) : super(adapter);

  final String tableName = 'message';

  @override
  // TODO: implement fields
  Map<String, Field> get fields => null;

  @override
  Message fromMap(Map map) {
    // TODO: implement fromMap
    return null;
  }

  @override
  List<SetColumn> toSetColumns(Message model, {bool update = false, Set<String> only}) {
    // TODO: implement toSetColumns
    return null;
  }
}
