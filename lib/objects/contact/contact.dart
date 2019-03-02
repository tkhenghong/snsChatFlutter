import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class Contact {
  String id;
  String displayName;
  String realName;
  String idName;
  String mobileNo;
  String lastSeenDate;
  bool block;
  Multimedia photo;

  Contact(
      {this.id,
      this.displayName,
      this.realName,
      this.idName,
      this.mobileNo,
      this.lastSeenDate,
      this.block,
      this.photo});
}
