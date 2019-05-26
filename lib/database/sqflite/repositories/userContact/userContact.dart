import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'userContact.jorm.dart';

class UserContact {
  UserContact({this.id, this.displayName, this.realName, this.userId, this.mobileNo, this.lastSeenDate, this.block});

  UserContact.make(this.id, this.displayName, this.realName, this.userId, this.mobileNo, this.lastSeenDate, this.block);

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

//  // TODO: Build table relationships
//  @Column(isNullable: true)
//  String photoId; // Multimedia object
}

@GenBean()
class UserContactBean extends Bean<UserContact> with _UserContactBean {
//class UserContactBean extends Bean<UserContact> {
  UserContactBean(Adapter adapter) : super(adapter);

  final String tableName = 'userContact';
}