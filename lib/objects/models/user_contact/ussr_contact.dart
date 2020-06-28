import 'package:lombok/lombok.dart';

@data
class UserContact {
  String id;
  String displayName;
  String realName;
  String about;
  List<String> userIds;
  String userId;
  String mobileNo;
  int lastSeenDate;
  bool block;
  String multimediaId;

  UserContact({this.id, this.displayName, this.realName, this.about, this.userIds, this.userId, this.mobileNo, this.lastSeenDate, this.block, this.multimediaId});

  factory UserContact.fromJson(Map<String, dynamic> json) {
    UserContact userContact = UserContact(
      id: json['id'],
      displayName: json['displayName'],
      realName: json['realName'],
      about: json['about'],
      userId: json['userId'],
      mobileNo: json['mobileNo'],
      lastSeenDate: json['lastSeenDate'],
      block: json['block'],
      multimediaId: json['multimediaId'],
    );

    var userIdsFromJson = json['userIds'];

    List<String> userIds = new List<String>.from(userIdsFromJson);
    userContact.userIds = userIds;

    return userContact;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'realName': realName,
        'about': about,
        'userId': userId,
        'userIds': userIds,
        'mobileNo': mobileNo,
        'lastSeenDate': lastSeenDate,
        'block': block,
        'multimediaId': multimediaId,
      };
}
