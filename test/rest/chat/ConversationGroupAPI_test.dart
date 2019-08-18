import 'package:snschat_flutter/backend/rest/chat/ConversationGroupAPIService.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  ConversationGroupAPIService conversationGroupAPIService = ConversationGroupAPIService();

  Conversation createTestObject() {
    return new Conversation(
      id: null,
      name: "Testing Group 1",
      description: "Testing description",
      type: "Single",
      createdDate: "107082019",
      timestamp: "5643484641654",
      notificationExpireDate: 254631654,
      creatorUserId: "65421654654651",
      memberIds: ["wadwadw56f4sef", "56s4f6r54g89e4g", "54hs564ju456dyth5jsr", "5t4s5g1erg65t4ae"],
      block: false,
    );
  }

  test("Test Create conversation", () async {
    Conversation conversation = createTestObject();
    Conversation newConversation = await conversationGroupAPIService.addConversation(conversation);
    print("newConversation.id:" + newConversation.id.toString());
    expect(newConversation.id, isNotEmpty);
  });

  test("Test Edit Conversation", () async {
    Conversation conversation = createTestObject();
    Conversation newConversation = await conversationGroupAPIService.addConversation(conversation);
    Conversation editedConversation = newConversation;
    editedConversation.name = "Test Group 2";
    editedConversation.type = "Group";
    editedConversation.description = "Edited Description";
    bool edited = await conversationGroupAPIService.editConversation(editedConversation);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get Conversation", () async {
    Conversation conversation = createTestObject();
    Conversation newConversation = await conversationGroupAPIService.addConversation(conversation);
    print("newConversation.id: " + newConversation.id);
    Conversation conversationFromServer = await conversationGroupAPIService.getSingleConversation(newConversation.id);
    print("conversationFromServer.id: " + conversationFromServer.id);
    print("conversationFromServer.id == newConversation.id:" + (conversationFromServer.id == newConversation.id).toString());
    expect(conversationFromServer.id == newConversation.id, isTrue);
  });

  test("Test Delete Conversation", () async {
    Conversation conversation = createTestObject();
    Conversation newConversation = await conversationGroupAPIService.addConversation(conversation);
    bool deleted = await conversationGroupAPIService.deleteConversation(newConversation.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get Conversations of A User", () async {
    // TODO
  });
}
