import 'dart:async';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'package:snschat_flutter/database/repositories/conversation_group/conversation_group.jorm.dart';

class Conversation {
  Conversation();

  Conversation.make(this.id, this.name, this.type, this.groupPhoto, this.unreadMessage, this.block, this.description,
      this.notificationExpireDate, this.contacts);

  // Single conversation, group conversation & broadcast channel
  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String name;

  @Column(isNullable: true)
  String type; // ChatGroupType object

  @Column(isNullable: true)
  String groupPhoto; // Multimedia object

  @Column(isNullable: true)
  String description;

  @Column(isNullable: true)
  bool block;

  @Column(isNullable: true)
  int notificationExpireDate; // 0 means notifications not blocked, > 0 means notifications are blocked until specified time.

  @Column(isNullable: true)
  String contacts; // List<UserContact> object

  @Column(isNullable: true)
  String unreadMessage; // UnreadMessage object

  @override
  String toString() {
    return 'Conversation{id: $id, name: $name, type: $type, groupPhoto: $groupPhoto, description: $description, block: $block, notificationExpireDate: $notificationExpireDate, contacts: $contacts, unreadMessage: $unreadMessage}';
  }
}

@GenBean()
class ConversationBean extends Bean<Conversation> with _ConversationBean {
  ConversationBean(Adapter adapter) : super(adapter);

  final String tableName = 'conversation_group';

  @override
  // TODO: implement fields
  Map<String, Field> get fields => null;

  @override
  Conversation fromMap(Map map) {
    // TODO: implement fromMap
    return null;
  }

  @override
  List<SetColumn> toSetColumns(Conversation model, {bool update = false, Set<String> only}) {
    // TODO: implement toSetColumns
    return null;
  }
}
