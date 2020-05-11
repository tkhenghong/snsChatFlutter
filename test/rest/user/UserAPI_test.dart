import 'package:snschat_flutter/rest/index.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/models/user/user.dart';

void main() {
  UserAPIService userAPIService = UserAPIService();

  User createTestObject() {
    return new User(
        id: null, mobileNo: "0182262663", displayName: "Teoh Kheng Hong", googleAccountId: "88888888", realName: "A.W.P G.H.O.S.T");
  }

  test("Test Create User", () async {
    User user = createTestObject();
    User newUser = await userAPIService.addUser(user);
    print("newUser.id:" + newUser.id.toString());
    expect(newUser.id, isNotEmpty);
  });

  test("Test Edit User", () async {
    User user = createTestObject();
    User newUser = await userAPIService.addUser(user);
    User editedUser = newUser;
    editedUser.mobileNo = "0182223991";
    editedUser.displayName = "KL Lam";
    editedUser.realName = "Teoh Kheng Lam";
    bool edited = await userAPIService.editUser(editedUser);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get User", () async {
    User user = createTestObject();
    User newUser = await userAPIService.addUser(user);
    User userFromServer = await userAPIService.getUser(newUser.id);
    print("userFromServer.id == newUser.id:" + (userFromServer.id == newUser.id).toString());
    expect(userFromServer.id == newUser.id, isTrue);
  });

  test("Test Delete User", () async {
    User user = createTestObject();
    User newUser = await userAPIService.addUser(user);
    print("newUser.id: " + newUser.id);
    bool deleted = await userAPIService.deleteUser(newUser.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get User By Using Google Account Id", () async {
    User user = createTestObject();
    User newUser = await userAPIService.addUser(user);
    User userFromServer = await userAPIService.getUserByUsingGoogleAccountId(user.googleAccountId);

    print("newUser.googleAccountId: " + newUser.googleAccountId);
    print("userFromServer.googleAccountId: " + userFromServer.googleAccountId);

    expect(userFromServer.googleAccountId, equals(newUser.googleAccountId));
  });

  test("Test Get User By Using Mobile No", () async {
    User user = createTestObject();
    User newUser = await userAPIService.addUser(user);
    User userFromServer = await userAPIService.getUserByUsingMobileNo(user.mobileNo);

    print("userFromServer.toString(): " + userFromServer.toString());
    print("newUser.mobileNo: " + newUser.mobileNo);
    print("userFromServer.mobileNo: " + userFromServer.mobileNo);

    expect(userFromServer.mobileNo, equals(newUser.mobileNo));
  });

  test("Test Get Users from a Conversation", () async {
    // TODO
  });
}
