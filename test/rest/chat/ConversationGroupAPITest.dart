import 'package:snschat_flutter/backend/rest/chat/ConversationGroupAPIService.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import 'package:flutter_test/flutter_test.dart';

class ConversationGroupAPITest {
  ConversationGroupAPIService conversationGroupAPIService;

  Conversation conversation = new Conversation(
    id: null,
    name: "Testing Group 1",
    description: "Testing description",
    type: "Single",
    createdDate: "107082019",
    timestamp: "5643484641654",
    notificationExpireDate: 6545649846541,
    creatorUserId: "65421654654651",
    memberIds: [
      "wadwadw56f4sef",
      "56s4f6r54g89e4g",
      "54hs564ju456dyth5jsr",
      "5t4s5g1erg65t4ae"
    ],
    block: false,
  );

  Future<Conversation> createConversation() async {
    Conversation newConversation =
        await conversationGroupAPIService.addConversation(conversation);

    if (isStringEmpty(conversation.id)) {
      print("conversation ID is not empty!");
    }

    return newConversation;
  }
}
