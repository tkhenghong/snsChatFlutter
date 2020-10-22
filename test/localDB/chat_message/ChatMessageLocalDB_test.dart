import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/index.dart';

void main() {
  ChatMessageAPIService chatMessageAPIService = ChatMessageAPIService();
  ChatMessageDBService messageDBService = ChatMessageDBService();

  CreateChatMessageRequest createTestObject() {
    return new CreateChatMessageRequest(conversationId: "wadhawidafgrs", messageContent: "bla bla bla");
  }

  test("Test Create ChatMessage Locally", () async {
    CreateChatMessageRequest createChatMessageRequest = createTestObject();

    ChatMessage newMessage = await chatMessageAPIService.addChatMessage(createChatMessageRequest);
    print("newMessage.id:" + newMessage.id.toString());
    await messageDBService.addChatMessage(newMessage);
    ChatMessage messageFromLocalDB = await messageDBService.getSingleChatMessage(newMessage.id);

    expect(newMessage.id, isNotEmpty);
    expect(messageFromLocalDB.id, equals(newMessage.id));
  });

  test("Test Get ChatMessage Locally", () async {
    CreateChatMessageRequest createChatMessageRequest = createTestObject();

    ChatMessage newMessage = await chatMessageAPIService.addChatMessage(createChatMessageRequest);
    await messageDBService.addChatMessage(newMessage);

    ChatMessage messageFromServer = await chatMessageAPIService.getSingleChatMessage(newMessage.id);
    ChatMessage messageFromLocalDB = await messageDBService.getSingleChatMessage(messageFromServer.id);

    expect(messageFromServer.id, equals(newMessage.id));
    expect(messageFromLocalDB.id, equals(messageFromServer.id));
  });

  test("Test Get Messages from a Conversation Locally", () async {
    // TODO
  });
}
