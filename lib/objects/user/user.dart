import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';

class User {
  String id;
  String displayName;
  String realName;
  String mobileNo;
  String firebaseUserId;

  User({
    this.id,
    this.displayName,
    this.realName,
    this.mobileNo,
    this.firebaseUserId,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        displayName = json['displayName'],
        realName = json['realName'],
        mobileNo = json['mobileNo'],
        firebaseUserId = json['firebaseUserId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'realName': realName,
        'mobileNo': mobileNo,
        'firebaseUserId': firebaseUserId,
      };
}
