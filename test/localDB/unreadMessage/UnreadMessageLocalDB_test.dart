import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:uuid/uuid.dart';

void main() {
  UnreadMessageDBService unreadMessageDBService = new UnreadMessageDBService();

  var uuid = Uuid();

  UnreadMessage createTestObject() {
    UnreadMessage unreadMessage = UnreadMessage(
      id: uuid.v4(),
      conversationId: uuid.v4(),
      userId: uuid.v4(),
      lastMessage: uuid.v4(),
      count: new Random().nextInt(99),
    );

    // Auditable
    unreadMessage.createdBy = uuid.v4();
    unreadMessage.createdDate = DateTime.now();
    unreadMessage.lastModifiedBy = uuid.v4();
    unreadMessage.lastModifiedDate = DateTime.now();
    unreadMessage.version = 1;
    return unreadMessage;
  }

  wipeAllUnreadMessage() async {
    await unreadMessageDBService.deleteAllUnreadMessage();
  }

  test('Create UnreadMessage', () async {
    await wipeAllUnreadMessage();
    UnreadMessage unreadMessage = createTestObject();

    // Add
    bool added = await unreadMessageDBService.addUnreadMessage(unreadMessage);

    // Get
    UnreadMessage unreadMessageFromLocalDB = await unreadMessageDBService.getSingleUnreadMessage(unreadMessage.id);

    // Validations
    expect(added, isTrue);
    expect(unreadMessageFromLocalDB, isNotNull);
    expect(unreadMessageFromLocalDB.id, isNotNull);
    expect(unreadMessageFromLocalDB.id, equals(unreadMessage.id)); // Only comparing IDs due to no equatable package
  }, retry: 3);

  // NOTE: Asynchronous saving the same thing into DB
  // Answer: You will not even getting the database even after delayed for 5 seconds after you have saved the same conversation group twice into DB.
  test('Create UnreadMessage Asynchronously', () async {
    await wipeAllUnreadMessage();
    UnreadMessage unreadMessage = createTestObject();

    // Add
    unreadMessageDBService.addUnreadMessage(unreadMessage);

    // Edit
    unreadMessage.lastMessage = uuid.v4();

    // Add
    unreadMessageDBService.addUnreadMessage(unreadMessage);

    UnreadMessage unreadMessageFromLocalDB = await unreadMessageDBService.getSingleUnreadMessage(unreadMessage.id);

    // Validations
    expect(unreadMessageFromLocalDB, isNull);
  }, retry: 3);

  test('Create and Edit UnreadMessage', () async {
    await wipeAllUnreadMessage();

    UnreadMessage unreadMessage = createTestObject();

    // Add
    bool added;
    try {
      added = await unreadMessageDBService.addUnreadMessage(unreadMessage);
    } catch (e) {
      print('Create and Edit UnreadMessage failed. e: $e');
      added = false;
    }

    // Get
    UnreadMessage unreadMessageFromLocalDB = await unreadMessageDBService.getSingleUnreadMessage(unreadMessage.id);

    // Edit
    unreadMessage.lastMessage = uuid.v4();

    // Edit in DB
    bool edited = await unreadMessageDBService.editUnreadMessage(unreadMessage);
    UnreadMessage editedUnreadMessage = await unreadMessageDBService.getSingleUnreadMessage(unreadMessage.id);

    // Validations
    expect(added, isTrue);
    expect(edited, isTrue);
    expect(unreadMessageFromLocalDB, isNotNull);
    expect(editedUnreadMessage.id, isNotNull);
    expect(editedUnreadMessage.id, equals(unreadMessageFromLocalDB.id));
    expect(editedUnreadMessage.lastMessage, isNotNull);
    expect(editedUnreadMessage.lastMessage, equals(unreadMessage.lastMessage));
  }, retry: 3);

  test('Test Save UnreadMessage Multiple Times', () async {
    await wipeAllUnreadMessage();
    UnreadMessage unreadMessage = createTestObject();
    int noOfSaves = 50;

    bool added = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      try {
        bool added2 = await unreadMessageDBService.addUnreadMessage(unreadMessage);
        // If one save is now saved successfully, the added variable will be false.
        if (!added2) {
          added = false;
        }
      } catch (e) {
        print('Save UnreadMessage multiple times failed. e: $e');
        added = false;
      }
    }

    // Get
    List<UnreadMessage> unreadMessageList = await unreadMessageDBService.getAllUnreadMessage();

    expect(added, isTrue);
    expect(unreadMessageList.length, equals(1));
  }, retry: 3);

  test('Test Delete Single UnreadMessage', () async {
    await wipeAllUnreadMessage();
    UnreadMessage unreadMessage = createTestObject();

    // Add
    bool added = await unreadMessageDBService.addUnreadMessage(unreadMessage);

    // Delete
    bool deleted = await unreadMessageDBService.deleteUnreadMessage(unreadMessage.id);

    // Get
    UnreadMessage unreadMessageFromLocalDB = await unreadMessageDBService.getSingleUnreadMessage(unreadMessage.id);

    expect(added, isTrue);
    expect(deleted, isTrue);
    expect(unreadMessageFromLocalDB, null);
  }, retry: 3);

  test('Test Wipe All UnreadMessage', () async {
    await wipeAllUnreadMessage();

    // Get
    List<UnreadMessage> unreadMessage = await unreadMessageDBService.getAllUnreadMessage();

    expect(unreadMessage, equals([]));
    expect(unreadMessage.length, equals(0));
  }, retry: 3);

  test('Test UnreadMessage with Pagination', () async {
    await wipeAllUnreadMessage();

    // Set up
    List<UnreadMessage> allUnreadMessage = [];

    String randomConversationGroupId = uuid.v4();

    int noOfSaves = 50;

    int numberOfPages = 5;

    int paginationSize = 10;

    expect(numberOfPages * paginationSize, equals(noOfSaves));

    bool allSavedSuccess = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      UnreadMessage unreadMessage = createTestObject();

      if (i == 25) {
        unreadMessage.conversationId = randomConversationGroupId;
      }

      allUnreadMessage.add(unreadMessage);

      bool added = await unreadMessageDBService.addUnreadMessage(unreadMessage);

      if (!added) {
        allSavedSuccess = false;
      }
    }

    expect(allSavedSuccess, isTrue);

    // Get
    UnreadMessage randomUserIdUnreadMessage = await unreadMessageDBService.getUnreadMessageOfAConversationGroup(randomConversationGroupId);

    expect(randomUserIdUnreadMessage, isNotNull);
    expect(randomUserIdUnreadMessage.conversationId, equals(randomConversationGroupId));
  }, retry: 3);
}
