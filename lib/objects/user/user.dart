
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
