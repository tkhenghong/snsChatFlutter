import 'package:snschat_flutter/backend/rest/chat/ConversationGroupAPIService.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test Create conversation", () async {
    ConversationGroupAPIService conversationGroupAPIService =
        ConversationGroupAPIService();
    print("Test start!");
    Conversation conversation = new Conversation(
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
    print("conversation.id:" + conversation.id.toString());
    print("conversation.name:" + conversation.name);
    print("conversation.description:" + conversation.description);
    print("conversation.type:" + conversation.type);
    print("conversation.createdDate:" + conversation.createdDate);
    print("conversation.timestamp:" + conversation.timestamp);

    print("Executing test now....");
    expect(await conversationGroupAPIService.addConversation(conversation),
        conversation);
  });
}
