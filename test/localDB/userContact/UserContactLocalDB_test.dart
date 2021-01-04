import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:uuid/uuid.dart';

void main() {
  UserContactDBService userContactDBService = new UserContactDBService();

  var uuid = Uuid();

  UserContact createTestObject() {
    UserContact userContact = UserContact(
      id: uuid.v4(),
      displayName: uuid.v4(),
      realName: uuid.v4(),
      about: uuid.v4(),
      userIds: [uuid.v4(), uuid.v4(), uuid.v4()],
      userId: uuid.v4(),
      mobileNo: uuid.v4(),
      countryCode: uuid.v4(),
      block: false,
      profilePicture: uuid.v4(),
    );

    // Auditable
    userContact.createdBy = uuid.v4();
    userContact.createdDate = DateTime.now();
    userContact.lastModifiedBy = uuid.v4();
    userContact.lastModifiedDate = DateTime.now();
    userContact.version = 1;
    return userContact;
  }

  wipeAllUserContacts() async {
    await userContactDBService.deleteAllUserContacts();
  }

  test('Create User Contact', () async {
    await wipeAllUserContacts();
    UserContact userContact = createTestObject();

    // Add
    bool added = await userContactDBService.addUserContact(userContact);
    UserContact userContactFromLocalDB = await userContactDBService.getSingleUserContact(userContact.id);

    // Validations
    expect(added, isTrue);
    expect(userContactFromLocalDB, isNotNull);
    expect(userContactFromLocalDB.id, isNotNull);
    expect(userContactFromLocalDB.id, equals(userContact.id)); // Only comparing IDs due to no equatable package
  });

  // NOTE: Asynchronous saving the same thing into DB
  // Answer: You will not even getting the database even after delayed for 5 seconds after you have saved the same conversation group twice into DB.
  test('Create User Contact Asynchronously', () async {
    await wipeAllUserContacts();
    UserContact userContact = createTestObject();

    // Add
    userContactDBService.addUserContact(userContact);

    // Edit
    userContact.displayName = uuid.v4();
    userContact.realName = uuid.v4();
    userContact.about = uuid.v4();
    userContact.mobileNo = uuid.v4();
    userContact.countryCode = uuid.v4();
    userContact.block = true;
    userContact.profilePicture = uuid.v4();

    // Add
    userContactDBService.addUserContact(userContact);

    // Get
    UserContact userContactFromLocalDB = await userContactDBService.getSingleUserContact(userContact.id);

    // Validations
    expect(userContactFromLocalDB, isNull);
  });

  test('Create and Edit User Contact', () async {
    await wipeAllUserContacts();
    UserContact userContact = createTestObject();

    // Add
    bool added;
    try {
      added = await userContactDBService.addUserContact(userContact);
    } catch (e) {
      print('Create and Edit User Contact failed. e: $e');
      added = false;
    }

    // Get
    UserContact userContactFromLocalDB = await userContactDBService.getSingleUserContact(userContact.id);

    // Edit
    userContact.displayName = uuid.v4();
    userContact.realName = uuid.v4();
    userContact.about = uuid.v4();
    userContact.mobileNo = uuid.v4();
    userContact.countryCode = uuid.v4();
    userContact.block = true;
    userContact.profilePicture = uuid.v4();

    // Edit in DB
    bool edited = await userContactDBService.editUserContact(userContact);
    UserContact editedUserContact = await userContactDBService.getSingleUserContact(userContact.id);

    // Validations
    expect(added, isTrue);
    expect(edited, isTrue);
    expect(userContactFromLocalDB, isNotNull);
    expect(editedUserContact.id, isNotNull);
    expect(editedUserContact.id, equals(userContactFromLocalDB.id));
    expect(editedUserContact.displayName, isNotNull);
    expect(editedUserContact.displayName, equals(userContact.displayName));
    expect(editedUserContact.realName, isNotNull);
    expect(editedUserContact.realName, equals(userContact.realName));
    expect(editedUserContact.about, isNotNull);
    expect(editedUserContact.about, equals(userContact.about));
    expect(editedUserContact.mobileNo, isNotNull);
    expect(editedUserContact.mobileNo, equals(userContact.mobileNo));
    expect(editedUserContact.countryCode, isNotNull);
    expect(editedUserContact.countryCode, equals(userContact.countryCode));
    expect(editedUserContact.block, isNotNull);
    expect(editedUserContact.block, equals(userContact.block));
    expect(editedUserContact.profilePicture, isNotNull);
    expect(editedUserContact.profilePicture, equals(userContact.profilePicture));
  });

  test('Test Save User Contact Multiple Times', () async {
    await wipeAllUserContacts();
    UserContact userContact = createTestObject();
    int noOfSaves = 50;

    bool added = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      try {
        bool added2 = await userContactDBService.addUserContact(userContact);
        // If one save is now saved successfully, the added variable will be false.
        if (!added2) {
          added = false;
        }
      } catch (e) {
        print('Save User Contact multiple times failed. e: $e');
        added = false;
      }
    }

    // Get
    List<UserContact> userContacts = await userContactDBService.getAllUserContacts();

    expect(added, isTrue);
    expect(userContacts.length, equals(1));
  });

  test('Test Delete Single User Contact', () async {
    await wipeAllUserContacts();
    UserContact userContact = createTestObject();

    // Add
    bool added = await userContactDBService.addUserContact(userContact);

    // Delete
    bool deleted = await userContactDBService.deleteUserContact(userContact.id);

    UserContact userContactFromLocalDB = await userContactDBService.getSingleUserContact(userContact.id);

    expect(added, isTrue);
    expect(deleted, isTrue);
    expect(userContactFromLocalDB, null);
  });

  test('Test Wipe All User Contacts', () async {
    await wipeAllUserContacts();

    // Add
    List<UserContact> userContacts = await userContactDBService.getAllUserContacts();

    expect(userContacts, equals([]));
    expect(userContacts.length, equals(0));
  });

  /// A test of loading conversation groups with pagination to test offline capability of the app when network is not available.
  /// A sample of noOfSaves of records will be save into Database. Then load first page of records and check the first element of the result.
  test('Test User Contacts with Pagination', () async {
    await wipeAllUserContacts();

    // Set up
    List<UserContact> allUserContacts = [];

    int noOfRecords = 50;

    int numberOfPages = 5;

    int paginationSize = 10;

    expect(numberOfPages * paginationSize, equals(noOfRecords));

    bool allSavedSuccess = true;

    // Add
    for (int i = 0; i < noOfRecords; i++) {
      UserContact userContact = createTestObject();

      allUserContacts.add(userContact);

      bool added = await userContactDBService.addUserContact(userContact);

      if (!added) {
        allSavedSuccess = false;
      }
    }

    // Sort by lastModifiedDate.
    allUserContacts.sort((UserContact userContactA, UserContact userContactB) {
      return userContactB.lastModifiedDate.millisecondsSinceEpoch - userContactA.lastModifiedDate.millisecondsSinceEpoch;
    });

    expect(allSavedSuccess, isTrue);
    int index = 0;
    // Load every page, check it's first element and the last element of the list to prove the pagination is loaded correctly.
    // Accessing first and last element of the list pattern: 0-9, 10-19, 20-29, 30-39.....
    for (int i = 0; i < numberOfPages; i++) {
      List<UserContact> firstPageUserContacts = await userContactDBService.getAllUserContactsWithPagination(i, paginationSize);

      UserContact firstElementInList = firstPageUserContacts.first;
      UserContact lastElementInList = firstPageUserContacts.last;

      expect(firstPageUserContacts, isNotNull);
      expect(firstPageUserContacts, isNotEmpty);
      expect(firstPageUserContacts.length, equals(paginationSize));
      expect(firstElementInList.id, allUserContacts[index].id); // 0

      // Move index to last element of the list.
      index += paginationSize; // 0 + 10 = 10
      index--; // 9
      expect(lastElementInList.id, allUserContacts[index].id);
      index++; // 10 // Move index to next page first element of the list.
    }
  });
}
