class Settings {
  String id;
  String userId;
  bool notification;


  Settings({this.id, this.userId, this.notification});

  Settings.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        notification = json['notification'];

  Map<String, dynamic> toJson() => {'id': id, 'userId': userId, 'notification': notification};
}
