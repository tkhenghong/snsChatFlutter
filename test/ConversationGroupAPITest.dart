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
      memberIds: [
        "wadwadw56f4sef",
        "56s4f6r54g89e4g",
        "54hs564ju456dyth5jsr",
        "5t4s5g1erg65t4ae"
      ],
      block: false,
    );
  }

  test("Test Create conversation", () async {

    print("Test start!");
    Conversation conversation = createTestObject();
    print("conversation.id:" + conversation.id.toString());
    print("conversation.name:" + conversation.name);
    print("conversation.description:" + conversation.description);
    print("conversation.type:" + conversation.type);
    print("conversation.createdDate:" + conversation.createdDate);
    print("conversation.timestamp:" + conversation.timestamp);

    print("Executing test now....");
    Conversation newConversation = await conversationGroupAPIService.addConversation(conversation);
    print("newConversation.id:" + newConversation.id.toString());
//    expect(await conversationGroupAPIService.addConversation(conversation),
//        conversation);
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
}
