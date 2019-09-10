import 'package:snschat_flutter/backend/rest/chat/ConversationGroupAPIService.dart';
import 'package:snschat_flutter/database/sembast/conversation_group/conversation_group.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import 'package:flutter_test/flutter_test.dart';

// TODO: These tests will be using both REST API and Local DB
void main() {
  ConversationGroupAPIService conversationGroupAPIService = ConversationGroupAPIService();
  ConversationDBService conversationGroupDBService = new ConversationDBService();

  ConversationGroup createTestObject() {
    return new ConversationGroup(
      id: null,
      name: "Testing Group 1",
      description: "Testing description",
      type: "Personal",
      createdDate: new DateTime.now().millisecondsSinceEpoch,
      notificationExpireDate: 254631654,
      creatorUserId: "65421654654651",
      memberIds: ["wadwadw56f4sef", "56s4f6r54g89e4g", "54hs564ju456dyth5jsr", "5t4s5g1erg65t4ae"],
      adminMemberIds: ["g9hf865465fhb6t54"],
      block: false,
    );
  }

  test("Test Create Conversation Group Locally", () async {
    ConversationGroup conversationGroup = createTestObject();

    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    print("newConversationGroup.id:" + newConversationGroup.id.toString());
    // TODO: Check the value of the boolean return by DB service
    bool added = await conversationGroupDBService.addConversationGroup(newConversationGroup);
    ConversationGroup conversationGroupFromLocalDB = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);
    print("conversationGroupFromLocalDB.id: " + conversationGroupFromLocalDB.id);
    // Validations
    expect(newConversationGroup.id, isNotEmpty);
    expect(conversationGroupFromLocalDB.id, equals(newConversationGroup.id)); // Only comparing ids due to no equatable package
  });

  test("Test Edit Conversation Group Locally", () async {
    ConversationGroup conversationGroup = createTestObject();

    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    await conversationGroupDBService.addConversationGroup(newConversationGroup);

    // Edit
    ConversationGroup editedConversationGroup = newConversationGroup;
    editedConversationGroup.name = "Test Group 2";
    editedConversationGroup.type = "Group";
    editedConversationGroup.description = "Edited Description";

    bool edited = await conversationGroupAPIService.editConversationGroup(editedConversationGroup);
    // Edit in DB
    await conversationGroupDBService.editConversationGroup(editedConversationGroup);
    ConversationGroup conversationGroupFromLocalDB = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);

    //Validations
    expect(conversationGroupFromLocalDB.id, equals(editedConversationGroup.id));
    expect(conversationGroupFromLocalDB.name, equals(editedConversationGroup.name));
    expect(conversationGroupFromLocalDB.type, equals(editedConversationGroup.type));
    expect(conversationGroupFromLocalDB.description, equals(editedConversationGroup.description));
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get Conversation Group Locally", () async {
    ConversationGroup conversationGroup = createTestObject();

    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    await conversationGroupDBService.addConversationGroup(newConversationGroup);
    print("newConversationGroup.id: " + newConversationGroup.id);

    ConversationGroup conversationGroupFromServer = await conversationGroupAPIService.getSingleConversationGroup(newConversationGroup.id);
    // Take the id from the conversationGroupFromServer and put it into local DB to search
    ConversationGroup conversationGroupFromLocalDB = await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id);

    print("conversationGroupFromServer.id: " + conversationGroupFromServer.id);
    print("conversationGroupFromServer.id == newConversation.id:" + (conversationGroupFromServer.id == newConversationGroup.id).toString());
    print("conversationGroupFromLocalDB.id == conversationGroupFromServer.id:" +
        (conversationGroupFromLocalDB.id == conversationGroupFromServer.id).toString());

    // Expect newConversationGroup.id == conversationGroupFromServer.id == conversationGroupFromLocalDB.id
    expect(conversationGroupFromServer.id, equals(newConversationGroup.id));
    expect(conversationGroupFromLocalDB.id, equals(conversationGroupFromServer.id));
  });

  test("Test Delete Conversation Group Locally", () async {
    ConversationGroup conversationGroup = createTestObject();

    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    await conversationGroupDBService.addConversationGroup(newConversationGroup);

    // Delete
    bool deleted = await conversationGroupAPIService.deleteConversationGroup(conversationGroup.id);
    await conversationGroupDBService.deleteConversationGroup(conversationGroup.id);

    print("deleted:" + deleted.toString());
    // Expect deleted is OK from server and unable to find the object in Local DB
    expect(deleted, isTrue);
    expect(await conversationGroupDBService.getSingleConversationGroup(conversationGroup.id), null);
  });

  test("Test Get Conversation Groups of A User Locally", () async {
    // TODO
  });
}
