import 'package:snschat_flutter/general/functions/repeating_functions.dart';

class Settings {
  String id;
  bool notification;

  Settings({this.id, this.notification});

  Settings.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        notification = json['notification'];

  Map<String, dynamic> toJson() => {'id': id, 'notification': notification};
}
