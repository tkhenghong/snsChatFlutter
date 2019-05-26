import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'user.jorm.dart';

class User {
  User({this.id,
    this.displayName,
    this.realName,
    this.userId,
    this.mobileNo,
    this.settings,
    this.firebaseUserId,
//    this.googleSignIn,
//    this.firebaseAuth
  });

  User.make(this.id,
      this.displayName,
      this.realName,
      this.userId,
      this.mobileNo,
      this.settings,
      this.firebaseUserId,
//      this.googleSignIn,
//      this.firebaseAuth
      );

  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String displayName;

  @Column(isNullable: true)
  String realName;

  @Column(isNullable: true)
  String userId;

  @Column(isNullable: true)
  String mobileNo;

  // TODO: Build table relationships
  @Column(isNullable: true)
  String settings; // Settings object

  @Column(isNullable: true)
  String firebaseUserId; // FirebaseUser object

//  // Cannot initialize anything here for flutter_bloc
//  @Column(isNullable: true)
//  String googleSignIn; // = new GoogleSignIn(); // GoogleSignIn object
//
//  @Column(isNullable: true)
//  String firebaseAuth; // = FirebaseAuth.instance; // FirebaseAuth object


}

@GenBean()
class UserBean extends Bean<User> with _UserBean {
//class UserBean extends Bean<User> {
  UserBean(Adapter adapter) : super(adapter);

  final String tableName = 'user';
}
