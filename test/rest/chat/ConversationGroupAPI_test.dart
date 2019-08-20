import 'package:snschat_flutter/backend/rest/chat/ConversationGroupAPIService.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  ConversationGroupAPIService conversationGroupAPIService = ConversationGroupAPIService();

  ConversationGroup createTestObject() {
    return new ConversationGroup(
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

  test("Test Create Conversation Group", () async {
    ConversationGroup conversationGroup = createTestObject();
    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    print("newConversationGroup.id:" + newConversationGroup.id.toString());
    expect(newConversationGroup.id, isNotEmpty);
  });

  test("Test Edit Conversation Group", () async {
    ConversationGroup conversationGroup = createTestObject();
    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    ConversationGroup editedConversationGroup = newConversationGroup;
    editedConversationGroup.name = "Test Group 2";
    editedConversationGroup.type = "Group";
    editedConversationGroup.description = "Edited Description";
    bool edited = await conversationGroupAPIService.editConversationGroup(editedConversationGroup);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get Conversation Group", () async {
    ConversationGroup conversationGroup = createTestObject();
    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    print("newConversationGroup.id: " + newConversationGroup.id);
    ConversationGroup conversationGroupFromServer = await conversationGroupAPIService.getSingleConversationGroup(newConversationGroup.id);
    print("conversationGroupFromServer.id: " + conversationGroupFromServer.id);
    print("conversationGroupFromServer.id == newConversation.id:" + (conversationGroupFromServer.id == newConversationGroup.id).toString());
    expect(conversationGroupFromServer.id == newConversationGroup.id, isTrue);
  });

  test("Test Delete Conversation Group", () async {
    ConversationGroup conversationGroup = createTestObject();
    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);
    bool deleted = await conversationGroupAPIService.deleteConversationGroup(newConversationGroup.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get Conversation Groups of A User", () async {
    // TODO
  });
}
