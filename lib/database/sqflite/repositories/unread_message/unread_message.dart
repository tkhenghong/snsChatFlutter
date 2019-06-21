import 'package:jaguar_orm/jaguar_orm.dart';

part 'unread_message.jorm.dart';

class UnreadMessage {
  UnreadMessage(
      {this.id, this.conversationId, this.lastMessage, this.date, this.count});

  UnreadMessage.make(
      this.id, this.conversationId, this.lastMessage, this.date, this.count);

  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String conversationId;

  @Column(isNullable: true)
  String lastMessage;

  @Column(isNullable: true)
  int date;

  @Column(isNullable: true)
  int count;

  @override
  String toString() {
    return 'UnreadMessage{id: $id, conversationId: $conversationId, lastMessage: $lastMessage, date: $date, count: $count}';
  }
}

@GenBean()
class UnreadMessageBean extends Bean<UnreadMessage> with _UnreadMessageBean {
  UnreadMessageBean(Adapter adapter) : super(adapter);

  final String tableName = 'unread_message';
}
