import 'package:snschat_flutter/objects/settings/settings.dart';

class User {
  String id;
  String displayName;
  String realName;
  String userId;
  String mobileNo;
  Settings settings;

  User(
      {this.id,
      this.displayName,
      this.realName,
      this.userId,
      this.mobileNo,
      this.settings});
}
