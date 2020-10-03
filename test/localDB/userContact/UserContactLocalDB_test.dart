import 'package:flutter_test/flutter_test.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

void main() {
  UserContactAPIService userContactAPIService = UserContactAPIService();
  UserContactDBService userContactDBService = UserContactDBService();

  UserContact createTestObject() {
    return new UserContact(
        id: null,
        realName: "Teoh Kheng Hong",
        displayName: "Hong KH",
        mobileNo: "+60182262663",
        userIds: ["5847rth54rt4h56sr4h"],
        block: false,
        lastSeenDate: new DateTime.now(),
        multimediaId: "54rdgr54gfrae5747486r");
  }

  test("Test Create UserContact Locally", () async {
    UserContact userContact = createTestObject();

    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    await userContactDBService.addUserContact(newUserContact);
    UserContact userContactFromLocalDB = await userContactDBService.getSingleUserContact(newUserContact.id);

    expect(newUserContact.id, isNotEmpty);
    expect(userContactFromLocalDB.id, equals(newUserContact.id));
  });

  test("Test Edit UserContact Locally", () async {
    UserContact userContact = createTestObject();

    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    await userContactDBService.addUserContact(newUserContact);

    UserContact editedUserContact = newUserContact;
    editedUserContact.realName = "Teoh Kheng Lam";
    editedUserContact.displayName = "KL Lam";
    editedUserContact.mobileNo = "+60182223991";
    editedUserContact.userIds = ["999999999"];

    bool edited = await userContactAPIService.editOwnUserContact(editedUserContact);
    await userContactDBService.editUserContact(editedUserContact);

    UserContact userContactFromLocalDB = await userContactDBService.getSingleUserContact(userContact.id);

    expect(userContactFromLocalDB.id, equals(editedUserContact.id));
    expect(userContactFromLocalDB.realName, equals(editedUserContact.realName));
    expect(userContactFromLocalDB.displayName, equals(editedUserContact.displayName));
    expect(userContactFromLocalDB.mobileNo, equals(editedUserContact.mobileNo));
    expect(userContactFromLocalDB.userIds, equals(editedUserContact.userIds));
    expect(edited, isTrue);
  });

  test("Test Get UserContact Locally", () async {
    UserContact userContact = createTestObject();

    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    await userContactDBService.addUserContact(newUserContact);

    UserContact userContactFromServer = await userContactAPIService.getUserContact(newUserContact.id);
    UserContact userContactFromLocalDB = await userContactDBService.getSingleUserContact(userContact.id);

    expect(userContactFromServer.id, equals(newUserContact.id));
    expect(userContactFromLocalDB.id, equals(userContactFromServer.id));
  });

  test("Test Get UserContact Locally By Using Mobile No", () async {
    UserContact userContact = createTestObject();

    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    await userContactDBService.addUserContact(newUserContact);

    UserContact userContactFromServer = await userContactAPIService.getUserContactByMobileNo(newUserContact.mobileNo);
    UserContact userContactFromLocalDB = await userContactDBService.getUserContactByMobileNo(userContact.mobileNo);

    expect(userContactFromServer.mobileNo, equals(newUserContact.mobileNo));
    expect(userContactFromLocalDB.mobileNo, equals(userContactFromServer.mobileNo));
  });

  test("Test Delete UserContact Locally", () async {
    UserContact userContact = createTestObject();

    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    await userContactDBService.addUserContact(newUserContact);

    bool deleted = await userContactAPIService.deleteUserContact(newUserContact.id);
    await userContactDBService.deleteUserContact(userContact.id);
    print("deleted:" + deleted.toString());

    expect(deleted, isTrue);
    expect(await userContactDBService.getSingleUserContact(userContact.id), null);
  });

  test("Test Get UserContacts from a Conversation Locally", () async {
    // TODO
  });
}
