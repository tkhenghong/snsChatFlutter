
class User {
  String id;
  String displayName;
  String realName;
  String mobileNo;
  String googleAccountId;

  User({
    this.id,
    this.displayName,
    this.realName,
    this.mobileNo,
    this.googleAccountId,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        displayName = json['displayName'],
        realName = json['realName'],
        mobileNo = json['mobileNo'],
        googleAccountId = json['googleAccountId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'realName': realName,
        'mobileNo': mobileNo,
        'googleAccountId': googleAccountId,
      };
}
