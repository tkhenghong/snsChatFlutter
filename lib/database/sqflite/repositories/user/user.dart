//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'user.jorm.dart';
// One User with Firebase ID, One Mobile No. One Mobile No. only belongs one Firebase**
class User {
  User({this.id,
    this.displayName,
    this.realName,
    this.mobileNo,
    this.googleAccountId,
  });

  User.make(this.id,
      this.displayName,
      this.realName,
      this.mobileNo,
      this.googleAccountId,
      );

  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String displayName;

  @Column(isNullable: true)
  String realName;

  @Column(isNullable: true)
  String mobileNo;

  @Column(isNullable: true)
  String googleAccountId; // FirebaseUser object

}

@GenBean()
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter) : super(adapter);

  final String tableName = 'user';
}
