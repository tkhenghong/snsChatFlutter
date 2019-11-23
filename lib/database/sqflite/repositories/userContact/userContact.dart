////Jaguar ORM
//import 'package:jaguar_query/jaguar_query.dart';
//import 'package:jaguar_orm/jaguar_orm.dart';
//
//part 'userContact.jorm.dart';
//
//// This is the contacts of the users from their phone storage, will be linked to Conversation object
//// Also called ConversationMember/GroupMember
//
//class UserContact {
//  UserContact(
//      {this.id,
//      this.displayName,
//      this.realName,
//      this.userId,
//      this.mobileNo,
//      this.lastSeenDate,
//      this.block});
//
//  UserContact.make(this.id, this.displayName, this.realName, this.userId,
//      this.mobileNo, this.lastSeenDate, this.block);
//
//  @PrimaryKey()
//  String id;
//
//  @Column(isNullable: true)
//  String
//      displayName; // Display the name of the user from the current user's contact storage
//
//  @Column(isNullable: true)
//  String realName; // Display the real name of the user from User table
//
//  @Column(isNullable: true)
//  String userId; // Always belong to a user in the User table
//
//  @Column(isNullable: true)
//  String mobileNo;
//
//  @Column(isNullable: true)
//  String lastSeenDate; // TODO: Should move to User table
//
//  @Column(isNullable: true)
//  bool block;
//
//  // This user contact should be belong to some conversation.
//  // Worried of same user but duplication? Actually there's a possibility of unknown mobile number from
//  // phone storage, I'm thinking of add the unknown number into this table first
//  // When that user signed up, that device will replace all user contact that using his mobile no in this table
//  // For group creator, When adding group members, the app will try
//  // to recognize the phone number from User table
//  @Column(isNullable: true)
//  String conversationId;
//}
//
//@GenBean()
//class UserContactBean extends Bean<UserContact> with _UserContactBean {
////class UserContactBean extends Bean<UserContact> {
//  UserContactBean(Adapter adapter) : super(adapter);
//
//  final String tableName = 'userContact';
//}
