class UnreadMessage {
  String id;
  String conversationId;
  String userId;
  String lastMessage;
  int date;
  int count;

  UnreadMessage({this.id, this.userId, this.conversationId, this.lastMessage, this.date, this.count});

  UnreadMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        conversationId = json['conversationId'],
        lastMessage = json['lastMessage'],
        date = json['date'],
        count = json['count'];

  Map<String, dynamic> toJson() => {'id': id, 'userId': userId, 'conversationId': conversationId, 'lastMessage': lastMessage, 'date': date, 'count': count};
}