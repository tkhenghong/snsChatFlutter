import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class UserContact {
  String id;
  String displayName;
  String realName;
  String userId;
  String mobileNo;
  String lastSeenDate;
  bool block;
  Multimedia photo;

  UserContact(
      {this.id,
      this.displayName,
      this.realName,
      this.userId,
      this.mobileNo,
      this.lastSeenDate,
      this.block,
      this.photo});
}
