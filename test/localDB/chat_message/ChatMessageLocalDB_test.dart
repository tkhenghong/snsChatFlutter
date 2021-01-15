import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:uuid/uuid.dart';

void main() {
  ChatMessageDBService chatMessageDBService = new ChatMessageDBService();

  var uuid = Uuid();

  ChatMessage createTestObject() {
    ChatMessage chatMessage = ChatMessage(
      id: uuid.v4(),
      conversationId: uuid.v4(),
      senderId: uuid.v4(),
      senderName: uuid.v4(),
      senderMobileNo: uuid.v4(),
      chatMessageStatus: ChatMessageStatus.Sent,
      messageContent: uuid.v4(),
      multimediaId: uuid.v4(),
    );
    chatMessage.createdBy = uuid.v4();
    chatMessage.createdDate = DateTime.now();
    chatMessage.lastModifiedBy = uuid.v4();
    chatMessage.lastModifiedDate = DateTime.now();
    chatMessage.version = 1;
    return chatMessage;
  }

  wipeAllChatMessages() async {
    await chatMessageDBService.deleteAllChatMessages();
  }

  test('Create Chat Message', () async {
    await wipeAllChatMessages();
    ChatMessage chatMessage = createTestObject();

    // Add
    bool added = await chatMessageDBService.addChatMessage(chatMessage);

    // Get
    ChatMessage chatMessageFromLocalDB = await chatMessageDBService.getSingleChatMessage(chatMessage.id);

    // Validations
    expect(added, isTrue);
    expect(chatMessageFromLocalDB, isNotNull);
    expect(chatMessageFromLocalDB.id, isNotNull);
    expect(chatMessageFromLocalDB.id, equals(chatMessage.id)); // Only comparing IDs due to no equatable package
  }, retry: 3);

  // NOTE: Asynchronous saving the same thing into DB
  // Answer: You will not even getting the database even after delayed for 5 seconds after you have saved the same conversation group twice into DB.
  test('Create Chat Message Asynchronously', () async {
    await wipeAllChatMessages();
    ChatMessage chatMessage = createTestObject();

    // Add
    chatMessageDBService.addChatMessage(chatMessage);

    // Edit
    chatMessage.messageContent = uuid.v4();

    // Add
    chatMessageDBService.addChatMessage(chatMessage);

    ChatMessage chatMessageFromLocalDB = await chatMessageDBService.getSingleChatMessage(chatMessage.id);

    // Validations
    expect(chatMessageFromLocalDB, isNull);
  }, retry: 3);

  test('Create and Edit Chat Message', () async {
    await wipeAllChatMessages();
    ChatMessage chatMessage = createTestObject();

    // Add
    bool added;
    try {
      added = await chatMessageDBService.addChatMessage(chatMessage);
    } catch (e) {
      print('Create and Edit Chat Message failed. e: $e');
      added = false;
    }

    // Get
    ChatMessage chatMessageFromLocalDB = await chatMessageDBService.getSingleChatMessage(chatMessage.id);

    // Edit
    chatMessage.messageContent = uuid.v4();
    chatMessage.chatMessageStatus = ChatMessageStatus.Read;

    bool edited = await chatMessageDBService.editChatMessage(chatMessage);
    ChatMessage editedChatMessage = await chatMessageDBService.getSingleChatMessage(chatMessage.id);

    // Validations
    expect(added, isTrue);
    expect(edited, isTrue);
    expect(chatMessageFromLocalDB, isNotNull);
    expect(editedChatMessage.id, isNotNull);
    expect(editedChatMessage.id, equals(chatMessageFromLocalDB.id));
    expect(editedChatMessage.messageContent, isNotNull);
    expect(editedChatMessage.messageContent, equals(chatMessage.messageContent));
    expect(editedChatMessage.chatMessageStatus, isNotNull);
    expect(editedChatMessage.chatMessageStatus, equals(chatMessage.chatMessageStatus));
  }, retry: 3);

  test('Test Save Chat Message Multiple Times', () async {
    await wipeAllChatMessages();
    // Set up
    ChatMessage chatMessage = createTestObject();

    int noOfRecords = 50;

    bool added = true;

    // Add
    for (int i = 0; i < noOfRecords; i++) {
      try {
        bool added2 = await chatMessageDBService.addChatMessage(chatMessage);
        // If one save is now saved successfully, the added variable will be false.
        if (!added2) {
          added = false;
        }
      } catch (e) {
        print('Save Chat Message multiple times failed. e: $e');
        added = false;
      }
    }

    // Get
    List<ChatMessage> chatMessages = await chatMessageDBService.getAllChatMessages();

    expect(added, isTrue);
    expect(chatMessages.length, equals(1));
  }, retry: 3);

  test('Test Delete Single Chat Message', () async {
    await wipeAllChatMessages();
    ChatMessage chatMessage = createTestObject();

    // Add
    bool added = await chatMessageDBService.addChatMessage(chatMessage);

    // Delete
    bool deleted = await chatMessageDBService.deleteChatMessage(chatMessage.id);

    // Get
    ChatMessage chatMessageFromLocalDB = await chatMessageDBService.getSingleChatMessage(chatMessage.id);

    expect(added, isTrue);
    expect(deleted, isTrue);
    expect(chatMessageFromLocalDB, null);
  }, retry: 3);

  test('Test Wipe All Chat Messages', () async {
    await wipeAllChatMessages();

    // Get
    List<ChatMessage> chatMessages = await chatMessageDBService.getAllChatMessages();

    expect(chatMessages, equals([]));
    expect(chatMessages.length, equals(0));
  }, retry: 3);

  /// A test of loading conversation groups with pagination to test offline capability of the app when network is not available.
  /// A sample of noOfSaves of records will be save into Database. Then load first page of records and check the first element of the result.
  test('Test Chat Messages with Pagination', () async {
    await wipeAllChatMessages();

    // Set up
    List<ChatMessage> allChatMessages = [];

    String randomConversationGroupID = uuid.v4();

    int noOfRecords = 50;

    int numberOfPages = 5;

    int paginationSize = 10;

    expect(numberOfPages * paginationSize, equals(noOfRecords));

    bool allSavedSuccess = true;

    // Add
    for (int i = 0; i < noOfRecords; i++) {
      ChatMessage chatMessage = createTestObject();
      chatMessage.conversationId = randomConversationGroupID;

      allChatMessages.add(chatMessage);

      bool added = await chatMessageDBService.addChatMessage(chatMessage);

      if (!added) {
        allSavedSuccess = false;
      }
    }

    // Sort by lastModifiedDate.
    allChatMessages.sort((ChatMessage chatMessageA, ChatMessage chatMessageB) {
      return chatMessageB.lastModifiedDate.millisecondsSinceEpoch - chatMessageA.lastModifiedDate.millisecondsSinceEpoch;
    });

    expect(allSavedSuccess, isTrue);

    // Get
    int index = 0;
    // Load every page, check it's first element and the last element of the list to prove the pagination is loaded correctly.
    // Accessing first and last element of the list pattern: 0-9, 10-19, 20-29, 30-39.....
    for (int i = 0; i < numberOfPages; i++) {
      List<ChatMessage> firstPageChatMessages = await chatMessageDBService.getAllChatMessagesWithPagination(randomConversationGroupID, i, paginationSize);

      ChatMessage firstElementInList = firstPageChatMessages.first;
      ChatMessage lastElementInList = firstPageChatMessages.last;

      // Validations
      expect(firstPageChatMessages, isNotNull);
      expect(firstPageChatMessages, isNotEmpty);
      expect(firstPageChatMessages.length, equals(paginationSize));
      expect(firstElementInList.id, allChatMessages[index].id); // 0

      // Move index to last element of the list.
      index += paginationSize; // 0 + 10 = 10
      index--; // 9
      expect(lastElementInList.id, allChatMessages[index].id);
      index++; // 10 // Move index to next page first element of the list.
    }
  }, retry: 3);
}
