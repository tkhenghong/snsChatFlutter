import 'package:snschat_flutter/backend/rest/userContact/UserContactAPIService.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

void main() {
  UserContactAPIService userContactAPIService = UserContactAPIService();

  UserContact createTestObject() {
    return new UserContact(
        id: null,
        realName: "Teoh Kheng Hong",
        displayName: "Hong KH",
        mobileNo: "+60182262663",
        conversationId: "rts68h54tsr56h4rsy47",
        userId: "5847rth54rt4h56sr4h",
        block: false,
        lastSeenDate: "19th August 2019");
  }

  test("Test Create UserContact", () async {
    UserContact userContact = createTestObject();
    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    print("newUserContact.id:" + newUserContact.id.toString());
    expect(newUserContact.id, isNotEmpty);
  });

  test("Test Edit UserContact", () async {
    UserContact userContact = createTestObject();
    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    UserContact editedUserContact = newUserContact;
    editedUserContact.realName = "Teoh Kheng Lam";
    editedUserContact.displayName = "KL Lam";
    editedUserContact.mobileNo = "+60182223991";
    editedUserContact.userId = "999999999";
    bool edited = await userContactAPIService.editUserContact(editedUserContact);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get UserContact", () async {
    UserContact userContact = createTestObject();
    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    UserContact userContactFromServer = await userContactAPIService.getUserContact(newUserContact.id);
    print("userContactFromServer.id == newUserContact.id:" + (userContactFromServer.id == newUserContact.id).toString());
    expect(userContactFromServer.id == newUserContact.id, isTrue);
  });

  test("Test Delete UserContact", () async {
    UserContact userContact = createTestObject();
    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    print("newUserContact.id: " + newUserContact.id);
    bool deleted = await userContactAPIService.deleteUserContact(newUserContact.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get UserContacts from a Conversation", () async {
    // TODO
  });
}
