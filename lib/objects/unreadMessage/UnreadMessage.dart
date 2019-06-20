class UnreadMessage {
  String id;
  String conversationId;
  String lastMessage;
  int date;
  int count;

  UnreadMessage({this.id, this.conversationId, this.lastMessage, this.date, this.count});

  UnreadMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        conversationId = json['conversationId'],
        lastMessage = json['lastMessage'],
        date = json['date'],
        count = json['count'];

  Map<String, dynamic> toJson() => {'id': id, 'conversationId': conversationId, 'lastMessage': lastMessage, 'date': date, 'count': count};
}