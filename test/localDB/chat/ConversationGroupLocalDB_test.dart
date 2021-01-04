import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:uuid/uuid.dart';

void main() {
  ConversationDBService conversationGroupDBService = new ConversationDBService();

  var uuid = Uuid();

  ConversationGroup createTestObject() {
    ConversationGroup conversationGroup = ConversationGroup(
      id: uuid.v4(),
      creatorUserId: uuid.v4(),
      name: uuid.v4(),
      conversationGroupType: ConversationGroupType.Personal,
      description: uuid.v4(),
      memberIds: [uuid.v4(), uuid.v4(), uuid.v4(), uuid.v4()],
      adminMemberIds: [uuid.v4()],
      groupPhoto: uuid.v4(),
    );
    conversationGroup.createdBy = uuid.v4();
    conversationGroup.createdDate = DateTime.now();
    conversationGroup.lastModifiedBy = uuid.v4();
    conversationGroup.lastModifiedDate = DateTime.now();
    conversationGroup.version = 1;
    return conversationGroup;
  }

  wipeAllConversationGroups() async {
    await conversationGroupDBService.deleteAllConversationGroups();
  }

  test('Create Conversation Group', () async {
    await wipeAllConversationGroups();
    ConversationGroup conversationGroup = createTestObject();

    // Add
    bool added = await conversationGroupDBService.addConversationGroup(conversationGroup);
    ConversationGroup conversationGroupFromLocalDB = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);

    // Validations
    expect(added, isTrue);
    expect(conversationGroupFromLocalDB, isNotNull);
    expect(conversationGroupFromLocalDB.id, isNotNull);
    expect(conversationGroupFromLocalDB.id, equals(conversationGroup.id)); // Only comparing IDs due to no equatable package
  });

  // NOTE: Asynchronous saving the same thing into DB
  // Answer: You will not even getting the database even after delayed for 5 seconds after you have saved the same conversation group twice into DB.
  test('Create Conversation Group Asynchronously', () async {
    await wipeAllConversationGroups();
    ConversationGroup conversationGroup = createTestObject();

    // Add
    conversationGroupDBService.addConversationGroup(conversationGroup);

    // Edit
    conversationGroup.name = uuid.v4();

    // Add
    conversationGroupDBService.addConversationGroup(conversationGroup);

    // Get
    ConversationGroup conversationGroupFromLocalDB = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);

    // Validations
    expect(conversationGroupFromLocalDB, isNull);
  });

  test('Create and Edit Conversation Group', () async {
    await wipeAllConversationGroups();
    ConversationGroup conversationGroup = createTestObject();

    // Add
    bool added;
    try {
      added = await conversationGroupDBService.addConversationGroup(conversationGroup);
    } catch (e) {
      print('Create and Edit Conversation Group failed. e: $e');
      added = false;
    }

    // Get
    ConversationGroup conversationGroupFromLocalDB = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);

    // Edit
    conversationGroup.name = uuid.v4();
    conversationGroup.conversationGroupType = ConversationGroupType.Group;
    conversationGroup.description = uuid.v4();

    // Edit in DB
    bool edited = await conversationGroupDBService.editConversationGroup(conversationGroup);
    ConversationGroup editedConversationGroup = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);

    // Validations
    expect(added, isTrue);
    expect(edited, isTrue);
    expect(conversationGroupFromLocalDB, isNotNull);
    expect(editedConversationGroup.id, isNotNull);
    expect(editedConversationGroup.id, equals(conversationGroupFromLocalDB.id));
    expect(editedConversationGroup.name, isNotNull);
    expect(editedConversationGroup.name, equals(conversationGroup.name));
    expect(editedConversationGroup.conversationGroupType, isNotNull);
    expect(editedConversationGroup.conversationGroupType, equals(conversationGroup.conversationGroupType));
    expect(editedConversationGroup.description, equals(conversationGroup.description));
  });

  /// This is to check Personal Conversation Group duplication prevention is working properly or not.
  test('Test Duplicate Personal Conversation Group', () async {
    await wipeAllConversationGroups();
    ConversationGroup conversationGroup = createTestObject();

    // Add
    bool added;
    try {
      added = await conversationGroupDBService.addConversationGroup(conversationGroup);
    } catch (e) {
      print('Create and Edit Conversation Group failed. e: $e');
      added = false;
    }

    // Get
    ConversationGroup conversationGroupFromLocalDB2 = await conversationGroupDBService.getConversationGroupWithTypeAndMembers(conversationGroup.conversationGroupType, conversationGroup.memberIds);

    // Validations
    expect(added, isTrue);
    expect(conversationGroup, isNotNull);
    expect(conversationGroupFromLocalDB2, isNotNull);
    expect(conversationGroupFromLocalDB2.id, isNotNull);
    expect(conversationGroup.id, equals(conversationGroupFromLocalDB2.id));
    expect(conversationGroup.memberIds, equals(conversationGroupFromLocalDB2.memberIds));
    expect(conversationGroup.adminMemberIds, equals(conversationGroupFromLocalDB2.adminMemberIds));
  });

  test('Test Save Conversation Group Multiple Times', () async {
    await wipeAllConversationGroups();
    ConversationGroup conversationGroup = createTestObject();
    int noOfSaves = 50;

    bool added = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      try {
        bool added2 = await conversationGroupDBService.addConversationGroup(conversationGroup);
        // If one save is now saved successfully, the added variable will be false.
        if (!added2) {
          added = false;
        }
      } catch (e) {
        print('Save Conversation Group multiple times failed. e: $e');
        added = false;
      }
    }

    // Get
    List<ConversationGroup> conversationGroups = await conversationGroupDBService.getAllConversationGroups();

    expect(added, isTrue);
    expect(conversationGroups.length, equals(1));
  });

  test('Test Delete Single Conversation Group', () async {
    await wipeAllConversationGroups();
    ConversationGroup conversationGroup = createTestObject();

    // Add
    bool added = await conversationGroupDBService.addConversationGroup(conversationGroup);

    // Delete
    bool deleted = await conversationGroupDBService.deleteConversationGroup(conversationGroup.id);

    ConversationGroup conversationGroupFromLocalDB = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);

    expect(added, isTrue);
    expect(deleted, isTrue);
    expect(conversationGroupFromLocalDB, null);
  });

  test('Test Wipe All Conversation Groups', () async {
    await wipeAllConversationGroups();

    // Add
    List<ConversationGroup> conversationGroups = await conversationGroupDBService.getAllConversationGroups();

    expect(conversationGroups, equals([]));
    expect(conversationGroups.length, equals(0));
  });

  /// A test of loading conversation groups with pagination to test offline capability of the app when network is not available.
  /// A sample of noOfSaves of records will be save into Database. Then load first page of records and check the first element of the result.
  test('Test Conversation Groups with Pagination', () async {
    await wipeAllConversationGroups();

    // Set up
    List<ConversationGroup> allConversationGroups = [];

    int noOfRecords = 50;

    int numberOfPages = 5;

    int paginationSize = 10;

    expect(numberOfPages * paginationSize, equals(noOfRecords));

    bool allSavedSuccess = true;

    // Add
    for (int i = 0; i < noOfRecords; i++) {
      ConversationGroup conversationGroup = createTestObject();

      allConversationGroups.add(conversationGroup);

      bool added = await conversationGroupDBService.addConversationGroup(conversationGroup);

      if (!added) {
        allSavedSuccess = false;
      }
    }

    // Sort by lastModifiedDate.
    allConversationGroups.sort((ConversationGroup conversationGroupA, ConversationGroup conversationGroupB) {
      return conversationGroupB.lastModifiedDate.millisecondsSinceEpoch - conversationGroupA.lastModifiedDate.millisecondsSinceEpoch;
    });

    expect(allSavedSuccess, isTrue);
    int index = 0;
    // Load every page, check it's first element and the last element of the list to prove the pagination is loaded correctly.
    // Accessing first and last element of the list pattern: 0-9, 10-19, 20-29, 30-39.....
    for (int i = 0; i < numberOfPages; i++) {
      List<ConversationGroup> firstPageConversationGroups = await conversationGroupDBService.getAllConversationGroupsWithPagination(i, paginationSize);

      ConversationGroup firstElementInList = firstPageConversationGroups.first;
      ConversationGroup lastElementInList = firstPageConversationGroups.last;

      expect(firstPageConversationGroups, isNotNull);
      expect(firstPageConversationGroups, isNotEmpty);
      expect(firstPageConversationGroups.length, equals(paginationSize));
      expect(firstElementInList.id, allConversationGroups[index].id); // 0

      // Move index to last element of the list.
      index += paginationSize; // 0 + 10 = 10
      index--; // 9
      expect(lastElementInList.id, allConversationGroups[index].id);
      index++; // 10 // Move index to next page first element of the list.
    }
  });
}
