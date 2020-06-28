import 'package:lombok/lombok.dart';

@data
class User {
  String id;
  String displayName;
  String realName;
  String mobileNo;
  String googleAccountId;
  String countryCode;
  String effectivePhoneNumber;

  User({this.id, this.displayName, this.realName, this.mobileNo, this.googleAccountId, this.countryCode, this.effectivePhoneNumber});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        displayName = json['displayName'],
        realName = json['realName'],
        mobileNo = json['mobileNo'],
        googleAccountId = json['googleAccountId'],
        countryCode = json['countryCode'],
        effectivePhoneNumber = json['effectivePhoneNumber'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'realName': realName,
        'mobileNo': mobileNo,
        'googleAccountId': googleAccountId,
        'countryCode': countryCode,
        'effectivePhoneNumber': effectivePhoneNumber,
      };
}
