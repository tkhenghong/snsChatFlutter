import 'package:snschat_flutter/backend/rest/user/UserAPIService.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/user/user.dart';
import 'package:snschat_flutter/objects/user/user.dart';

void main() {
  UserAPIService userAPIService = UserAPIService();
  UserDBService userDBService = UserDBService();

  User createTestObject() {
    return new User(
        id: null, mobileNo: "0182262663", displayName: "Teoh Kheng Hong", googleAccountId: "88888888", realName: "A.W.P G.H.O.S.T");
  }

  test("Test Create User Locally", () async {
    User user = createTestObject();

    User newUser = await userAPIService.addUser(user);
    await userDBService.addUser(newUser);
    User userFromLocalDB = await userDBService.getSingleUser(newUser.id);

    expect(newUser.id, isNotEmpty);
    expect(userFromLocalDB.id, equals(newUser.id));
  });

  test("Test Edit User Locally", () async {
    User user = createTestObject();

    User newUser = await userAPIService.addUser(user);
    await userDBService.addUser(newUser);

    User editedUser = newUser;
    editedUser.mobileNo = "0182223991";
    editedUser.displayName = "KL Lam";
    editedUser.realName = "Teoh Kheng Lam";

    bool edited = await userAPIService.editUser(editedUser);
    print("edited:" + edited.toString());
    await userDBService.editUser(editedUser);
    User userFromLocalDB = await userDBService.getSingleUser(user.id);

    expect(userFromLocalDB.id, equals(editedUser.id));
    expect(userFromLocalDB.mobileNo, equals(editedUser.mobileNo));
    expect(userFromLocalDB.displayName, equals(editedUser.displayName));
    expect(userFromLocalDB.realName, equals(editedUser.realName));
    expect(edited, isTrue);
  });

  test("Test Get User Locally", () async {
    User user = createTestObject();

    User newUser = await userAPIService.addUser(user);
    await userDBService.addUser(newUser);

    User userFromServer = await userAPIService.getUser(newUser.id);
    User userFromLocalDB = await userDBService.getSingleUser(user.id);

    expect(userFromServer.id, equals(newUser.id));
    expect(userFromLocalDB.id, equals(userFromServer.id));
  });

  test("Test Delete User Locally", () async {
    User user = createTestObject();

    User newUser = await userAPIService.addUser(user);
    await userDBService.addUser(newUser);

    bool deleted = await userAPIService.deleteUser(newUser.id);
    await userDBService.deleteUser(user.id);
    print("deleted:" + deleted.toString());

    expect(deleted, isTrue);
    expect(await userDBService.getSingleUser(user.id), null);
  });

  test("Test Get Users from a Conversation Locally", () async {
    // TODO
  });
}
