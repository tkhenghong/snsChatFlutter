import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class UserContact {
  String id;
  String displayName;
  String realName;
  String userId;
  String mobileNo;
  String lastSeenDate;
  bool block;
  String photoId; // Multimedia

  UserContact({this.id, this.displayName, this.realName, this.userId, this.mobileNo, this.lastSeenDate, this.block, this.photoId});

  UserContact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        displayName = json['displayName'],
        realName = json['realName'],
        userId = json['userId'],
        mobileNo = json['mobileNo'],
        lastSeenDate = json['lastSeenDate'],
        block = json['block'],
        photoId = json['photoId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'realName': realName,
        'userId': userId,
        'mobileNo': mobileNo,
        'lastSeenDate': lastSeenDate,
        'block': block,
        'photoId': photoId,
      };
}
