import 'dart:async';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'conversation_group.jorm.dart';

class Conversation {
  Conversation(
      {this.id,
      this.userId,
      this.name,
      this.type,
      this.groupPhotoId,
      this.unreadMessageId,
      this.block,
      this.description,
      this.notificationExpireDate,
      this.timestamp});

  Conversation.make(this.id, this.userId, this.name, this.type, this.groupPhotoId, this.unreadMessageId, this.block, this.description,
      this.notificationExpireDate, this.timestamp);

  // Single conversation, group conversation & broadcast channel
  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String userId;

  @Column(isNullable: true)
  String name;

  @Column(isNullable: true)
  String type; // ChatGroupType object

  @Column(isNullable: true)
  String groupPhotoId; // Multimedia object

  @Column(isNullable: true)
  String unreadMessageId;

  @Column(isNullable: true)
  String description;

  @Column(isNullable: true)
  bool block;

  @Column(isNullable: true)
  int notificationExpireDate; // 0 means notifications not blocked, > 0 means notifications are blocked until specified time.

//  @Column(isNullable: true)
//  List<UserContact> contacts; // List<UserContact> object

  @Column(isNullable: true)
  String timestamp;

  @override
  String toString() {
    return 'Conversation{id: $id, userId: $userId, name: $name, type: $type, groupPhotoId: $groupPhotoId, unreadMessageId: $unreadMessageId, description: $description, block: $block, notificationExpireDate: $notificationExpireDate, timestamp: $timestamp}';
  }
}

@GenBean()
class ConversationBean extends Bean<Conversation> with _ConversationBean {
//class ConversationBean extends Bean<Conversation> {
  ConversationBean(Adapter adapter) : super(adapter);

  final String tableName = 'conversation_group';
}
