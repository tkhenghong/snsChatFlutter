import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'package:snschat_flutter/database/sqflite/repositories/userContact/userContact.jorm.dart';

class UserContact {
  UserContact({this.id, this.displayName, this.realName, this.userId, this.mobileNo, this.lastSeenDate, this.block, this.photo});

  UserContact.make(this.id, this.displayName, this.realName, this.userId, this.mobileNo, this.lastSeenDate, this.block, this.photo);

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

  @Column(isNullable: true)
  String lastSeenDate;

  @Column(isNullable: true)
  bool block;

  // TODO: Build table relationships
  @Column(isNullable: true)
  String photo; // Multimedia object
}

@GenBean()
class UserContactBean extends Bean<UserContact> with _UserContactBean {
  UserContactBean(Adapter adapter) : super(adapter);

  final String tableName = 'userContact';

  @override
  // TODO: implement fields
  Map<String, Field> get fields => null;

  @override
  UserContact fromMap(Map map) {
    // TODO: implement fromMap
    return null;
  }

  @override
  List<SetColumn> toSetColumns(UserContact model, {bool update = false, Set<String> only}) {
    // TODO: implement toSetColumns
    return null;
  }
}