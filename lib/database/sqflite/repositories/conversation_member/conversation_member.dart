//import 'package:jaguar_orm/jaguar_orm.dart';
//import 'package:snschat_flutter/database/sqflite/repositories/userContact/userContact.dart';
//
//part 'conversation_member.jorm.dart';
//
//class ConversationMember extends UserContact {
//  ConversationMember({this.id, this.conversationId, this.name, this.contactNo}) : super();
//
//  ConversationMember.make(this.id, this.conversationId, this.name, this.contactNo) : super();
//
//  @PrimaryKey()
//  String id;
//
//  @Column(isNullable: true)
//  String conversationId;
//
//  @Column(isNullable: true)
//  String name;
//
//  @Column(isNullable: true)
//  String contactNo;
//
//  @override
//  String toString() {
//    return 'ConversationMember{id: $id, conversationId: $conversationId, name: $name, contactNo: $contactNo}';
//  }
//
//
//}
//
//@GenBean()
//class ConversationMemberBean extends Bean<ConversationMember> with _ConversationMemberBean {
////class UserContactBean extends Bean<UserContact> {
//
//  final String tableName = 'conversation_member';
//
//  ConversationMemberBean(Adapter adapter) : super(adapter);
//
//}