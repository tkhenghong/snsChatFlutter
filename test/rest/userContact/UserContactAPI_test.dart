import 'package:snschat_flutter/backend/rest/userContact/UserContactAPIService.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

// NOTE: I have made
void main() {
  UserContactAPIService userContactAPIService = UserContactAPIService();

  UserContact createTestObject() {
    return new UserContact(
        id: null,
        realName: "Teoh Kheng Hong",
        displayName: "Hong KH",
        mobileNo: "+60182262663",
        userIds: ["5847rth54rt4h56sr4h", "5d7385f079d3941d808f7e30"],
        block: false,
        lastSeenDate: new DateTime.now().millisecondsSinceEpoch,
        multimediaId: "54rdgr54gfrae5747486r");
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
    editedUserContact.userIds = ["999999999"];
    bool edited = await userContactAPIService.editUserContact(editedUserContact);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });


  test("Test Get UserContact", () async {
    UserContact userContact = createTestObject();
    print("Before send to server");
    print("userContact.lastSeenDate: "+ userContact.lastSeenDate.toString());
    DateTime lastSeenDateDT = new DateTime.fromMicrosecondsSinceEpoch(userContact.lastSeenDate);
    print("lastSeenDateDT.toIso8601String(): " + lastSeenDateDT.toIso8601String());
    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
    UserContact userContactFromServer = await userContactAPIService.getUserContact(newUserContact.id);
    expect(userContactFromServer.id == newUserContact.id, isTrue);
    expect(userContactFromServer.lastSeenDate == newUserContact.lastSeenDate, isTrue);
  });

  test("Test Get UserContact Locally By Using Mobile No", () async {
    UserContact userContact = createTestObject();

    UserContact newUserContact = await userContactAPIService.addUserContact(userContact);

    UserContact userContactFromServer = await userContactAPIService.getUserContactByMobileNo(newUserContact.mobileNo);

    expect(userContactFromServer.mobileNo, equals(newUserContact.mobileNo));
    expect(newUserContact.mobileNo, equals(userContact.mobileNo));
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
