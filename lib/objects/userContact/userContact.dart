import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class UserContact {
  String id;
  String conversationId;
  String displayName;
  String realName;
  List<String> userIds; // This UserContact is belonged to which user? // TODO: Move it to User, declare it as UserContactIds, which means how many contact does this User own?
  String mobileNo; // Mobile number of the User/Stranger. Will use a method to determine the phone number's origin country. (Require to do strict validation during sign up + SMS verification)
  String lastSeenDate;
  String multimediaId; // Show the user's picture. Uses the multimedia from the User itself. Show default user picture for strangers.
  bool block;

//  String photoId; // Multimedia // Moved to Multimedia

  UserContact({this.id, this.conversationId, this.displayName, this.realName, this.userIds, this.mobileNo, this.lastSeenDate, this.block, this.multimediaId});

  factory UserContact.fromJson(Map<String, dynamic> json) {
    UserContact userContact = UserContact(
      id: json['id'],
      conversationId: json['conversationId'],
      displayName: json['displayName'],
      realName: json['realName'],
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
        'conversationId': conversationId,
        'displayName': displayName,
        'realName': realName,
        'userIds': userIds,
        'mobileNo': mobileNo,
        'lastSeenDate': lastSeenDate,
        'block': block,
    'multimediaId': multimediaId,
      };
}
