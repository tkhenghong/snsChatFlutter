import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'package:snschat_flutter/database/sqflite/repositories/message/message.jorm.dart';

// system message or normal message, sticker, gifs, emojis, video, recording, photos,
class Message {
  Message({this.id, this.conversationId, this.recipient, this.type, this.status, this.message, this.multimedia});

  Message.make(this.id, this.conversationId, this.recipient, this.type, this.status, this.message, this.multimedia);

  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String conversationId;

  @Column(isNullable: true)
  String recipient; // Recipient object

  @Column(isNullable: true)
  String type;

  @Column(isNullable: true)
  String status; // Sent, received, unread, read

  @Column(isNullable: true)
  String message;

  // TODO: Build table relationships
  @Column(isNullable: true)
  String multimedia; // Multimedia object

  @override
  String toString() {
    return 'Message{id: $id, conversationId: $conversationId, recipient: $recipient, type: $type, status: $status, message: $message, multimedia: $multimedia}';
  }

}

@GenBean()
class MessageBean extends Bean<Message> with _MessageBean {
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
