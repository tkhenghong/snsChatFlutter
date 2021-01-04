import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:uuid/uuid.dart';

void main() {
  UserDBService userDBService = new UserDBService();

  var uuid = Uuid();

  User createTestObject() {
    User user = User(
      id: uuid.v4(),
      displayName: uuid.v4(),
      realName: uuid.v4(),
      emailAddress: uuid.v4(),
      countryCode: uuid.v4(),
      mobileNo: uuid.v4(),
    );

    // Auditable
    user.createdBy = uuid.v4();
    user.createdDate = DateTime.now();
    user.lastModifiedBy = uuid.v4();
    user.lastModifiedDate = DateTime.now();
    user.version = 1;
    return user;
  }

  wipeAllUser() async {
    await userDBService.deleteAllUsers();
  }

  test('Create User', () async {
    await wipeAllUser();
    User user = createTestObject();

    // Add
    bool added = await userDBService.addUser(user);

    // Get
    User userFromLocalDB = await userDBService.getSingleUser(user.id);

    // Validations
    expect(added, isTrue);
    expect(userFromLocalDB, isNotNull);
    expect(userFromLocalDB.id, isNotNull);
    expect(userFromLocalDB.id, equals(user.id)); // Only comparing IDs due to no equatable package
  });

  // NOTE: Asynchronous saving the same thing into DB
  // Answer: You will not even getting the database even after delayed for 5 seconds after you have saved the same conversation group twice into DB.
  test('Create User Asynchronously', () async {
    await wipeAllUser();
    User user = createTestObject();

    // Add
    userDBService.addUser(user);

    // Edit
    user.displayName = uuid.v4();
    user.realName = uuid.v4();
    user.emailAddress = uuid.v4();
    user.mobileNo = uuid.v4();
    user.countryCode = uuid.v4();

    // Add
    userDBService.addUser(user);

    User userFromLocalDB = await userDBService.getSingleUser(user.id);

    // Validations
    expect(userFromLocalDB, isNull);
  });

  test('Create and Edit User', () async {
    await wipeAllUser();

    User user = createTestObject();

    // Add
    bool added;
    try {
      added = await userDBService.addUser(user);
    } catch (e) {
      print('Create and Edit User failed. e: $e');
      added = false;
    }

    // Get
    User userFromLocalDB = await userDBService.getSingleUser(user.id);

    // Edit
    user.displayName = uuid.v4();
    user.realName = uuid.v4();
    user.emailAddress = uuid.v4();
    user.mobileNo = uuid.v4();
    user.countryCode = uuid.v4();

    // Edit in DB
    bool edited = await userDBService.editUser(user);
    User editedUser = await userDBService.getSingleUser(user.id);

    // Validations
    expect(added, isTrue);
    expect(edited, isTrue);
    expect(userFromLocalDB, isNotNull);
    expect(editedUser.id, isNotNull);
    expect(editedUser.id, equals(userFromLocalDB.id));
    expect(editedUser.displayName, isNotNull);
    expect(editedUser.displayName, equals(user.displayName));
    expect(editedUser.realName, isNotNull);
    expect(editedUser.realName, equals(user.realName));
    expect(editedUser.emailAddress, isNotNull);
    expect(editedUser.emailAddress, equals(user.emailAddress));
    expect(editedUser.mobileNo, isNotNull);
    expect(editedUser.mobileNo, equals(user.mobileNo));
    expect(editedUser.countryCode, isNotNull);
    expect(editedUser.countryCode, equals(user.countryCode));
  });

  test('Test Save User Multiple Times', () async {
    await wipeAllUser();
    User user = createTestObject();
    int noOfSaves = 50;

    bool added = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      try {
        bool added2 = await userDBService.addUser(user);
        // If one save is now saved successfully, the added variable will be false.
        if (!added2) {
          added = false;
        }
      } catch (e) {
        print('Save User multiple times failed. e: $e');
        added = false;
      }
    }

    // Get
    List<User> userList = await userDBService.getAllUsers();

    expect(added, isTrue);
    expect(userList.length, equals(1));
  });

  test('Test Delete Single User', () async {
    await wipeAllUser();
    User user = createTestObject();

    // Add
    bool added = await userDBService.addUser(user);

    // Delete
    bool deleted = await userDBService.deleteUser(user.id);

    // Get
    User userFromLocalDB = await userDBService.getSingleUser(user.id);

    expect(added, isTrue);
    expect(deleted, isTrue);
    expect(userFromLocalDB, null);
  });

  test('Test Wipe All User', () async {
    await wipeAllUser();

    // Get
    List<User> user = await userDBService.getAllUsers();

    expect(user, equals([]));
    expect(user.length, equals(0));
  });

  test('Test User with Pagination', () async {
    await wipeAllUser();

    // Set up
    List<User> allUser = [];

    String randomUserId = uuid.v4();
    String randomMobileNo = uuid.v4();

    int noOfSaves = 50;

    int numberOfPages = 5;

    int paginationSize = 10;

    expect(numberOfPages * paginationSize, equals(noOfSaves));

    bool allSavedSuccess = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      User user = createTestObject();

      if (i == 25) {
        user.mobileNo = randomMobileNo;
        user.id = randomUserId;
      }

      allUser.add(user);

      bool added = await userDBService.addUser(user);

      if (!added) {
        allSavedSuccess = false;
      }
    }

    expect(allSavedSuccess, isTrue);

    // Get
    User randomUserIdUser = await userDBService.getSingleUser(randomUserId);

    expect(randomUserIdUser, isNotNull);
    expect(randomUserIdUser.id, equals(randomUserId));
    expect(randomUserIdUser.mobileNo, equals(randomMobileNo));
  });
}
