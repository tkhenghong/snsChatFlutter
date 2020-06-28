import 'package:lombok/lombok.dart';

@data
class Settings {
  String id;
  String userId;
  bool allowNotifications;

  Settings({this.id, this.userId, this.allowNotifications});

  Settings.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        allowNotifications = json['allowNotifications'];

  Map<String, dynamic> toJson() => {'id': id, 'userId': userId, 'allowNotifications': allowNotifications};
}
