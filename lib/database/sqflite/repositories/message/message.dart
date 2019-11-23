////Jaguar ORM
//import 'package:jaguar_query/jaguar_query.dart';
//import 'package:jaguar_orm/jaguar_orm.dart';
//
//part 'message.jorm.dart';
//
//// system/normal message, sticker, gifs, emojis, video, recording, photos,
//class Message {
//  Message(
//      {this.id,
//      this.conversationId,
//      this.senderId,
//      this.senderName,
//      this.senderMobileNo,
//      this.receiverId,
//      this.receiverName,
//      this.receiverMobileNo,
//      this.type,
//      this.status,
//      this.message,
//      this.multimediaId,
//      this.timestamp});
//
//  Message.make(
//      this.id,
//      this.conversationId,
//      this.senderId,
//      this.senderName,
//      this.senderMobileNo,
//      this.receiverId,
//      this.receiverName,
//      this.receiverMobileNo,
//      this.type,
//      this.status,
//      this.message,
//      this.multimediaId,
//      this.timestamp);
//
//  @PrimaryKey()
//  String id;
//
//  @Column(isNullable: true)
//  String conversationId;
//
//  // Sender
//  @Column(isNullable: true)
//  String senderId;
//
//  @Column(isNullable: true)
//  String senderName;
//
//  @Column(isNullable: true)
//  String senderMobileNo;
//
//  // Receiver
//  @Column(isNullable: true)
//  String receiverId;
//
//  @Column(isNullable: true)
//  String receiverName;
//
//  @Column(isNullable: true)
//  String receiverMobileNo;
//
//  @Column(isNullable: true)
//  String type;
//
//  @Column(isNullable: true)
//  String status; // Sent, received, unread, read
//
//  @Column(isNullable: true)
//  String message;
//
//  @Column(isNullable: true)
//  String multimediaId;
//
//  @Column(isNullable: true)
//  String timestamp;
//
//  @override
//  String toString() {
//    return 'Message{id: $id, conversationId: $conversationId, senderId: $senderId, senderName: $senderName, senderMobileNo: $senderMobileNo, receiverId: $receiverId, receiverName: $receiverName, receiverMobileNo: $receiverMobileNo, type: $type, status: $status, message: $message, multimediaId: $multimediaId, timestamp: $timestamp}';
//  }
//}
//
//@GenBean()
//class MessageBean extends Bean<Message> with _MessageBean {
//  MessageBean(Adapter adapter) : super(adapter);
//
//  final String tableName = 'message';
//}
