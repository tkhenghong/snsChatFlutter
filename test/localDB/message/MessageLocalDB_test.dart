import 'package:flutter_test/flutter_test.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';

import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

void main() {
  MessageAPIService messageAPIService = MessageAPIService();
  ChatMessageDBService messageDBService = ChatMessageDBService();

  ChatMessage createTestObject() {
    return new ChatMessage(
      id: null,
      conversationId: "wadhawidafgrs",
      createdTime: new DateTime.now(),
      messageContent: "bla bla bla",
      type: ChatMessageType.Text,
      status: ChatMessageStatus.Read,
      senderName: "Teoh Kheng Hong",
      senderMobileNo: "+60182262663",
      senderId: "f9g87rd98g7r8e9g7",
      receiverName: "Teoh Kheng Lam",
      receiverMobileNo: "+60182223991",
      receiverId: "df09g809dg8df0",
      multimediaId: "seioghsriujgrsogr78gf9rg78",
    );
  }

  test("Test Create ChatMessage Locally", () async {
    ChatMessage message = createTestObject();

    ChatMessage newMessage = await messageAPIService.addMessage(message);
    print("newMessage.id:" + newMessage.id.toString());
    await messageDBService.addChatMessage(newMessage);
    ChatMessage messageFromLocalDB = await messageDBService.getSingleChatMessage(newMessage.id);

    expect(newMessage.id, isNotEmpty);
    expect(messageFromLocalDB.id, equals(newMessage.id));
  });

  test("Test Edit ChatMessage Locally", () async {
    ChatMessage message = createTestObject();

    ChatMessage newMessage = await messageAPIService.addMessage(message);
    await messageDBService.addChatMessage(newMessage);

    ChatMessage editedMessage = newMessage;
    editedMessage.messageContent = "Testing ChatMessage 2";
    editedMessage.type = ChatMessageType.Video;
    editedMessage.multimediaId = "edited multimedia ID";

    bool edited = await messageAPIService.editMessage(editedMessage);
    print("edited:" + edited.toString());
    await messageDBService.editChatMessage(editedMessage);
    ChatMessage messageFromLocalDB = await messageDBService.getSingleChatMessage(newMessage.id);

    expect(messageFromLocalDB.id, equals(editedMessage.id));
    expect(messageFromLocalDB.messageContent, equals(editedMessage.messageContent));
    expect(messageFromLocalDB.type, equals(editedMessage.type));
    expect(messageFromLocalDB.multimediaId, equals(editedMessage.multimediaId));
    expect(edited, isTrue);
  });

  test("Test Get ChatMessage Locally", () async {
    ChatMessage message = createTestObject();

    ChatMessage newMessage = await messageAPIService.addMessage(message);
    await messageDBService.addChatMessage(newMessage);

    ChatMessage messageFromServer = await messageAPIService.getSingleMessage(newMessage.id);
    ChatMessage messageFromLocalDB = await messageDBService.getSingleChatMessage(message.id);

    expect(messageFromServer.id, equals(newMessage.id));
    expect(messageFromLocalDB.id, equals(messageFromServer.id));
  });

  test("Test Delete ChatMessage Locally", () async {
    ChatMessage message = createTestObject();

    ChatMessage newMessage = await messageAPIService.addMessage(message);
    await messageDBService.addChatMessage(newMessage);

    bool deleted = await messageAPIService.deleteMessage(message.id);
    await messageDBService.deleteChatMessage(message.id);
    print("deleted:" + deleted.toString());

    expect(deleted, isTrue);
    expect(await messageDBService.getSingleChatMessage(message.id), null);
  });

  test("Test Get Messages from a Conversation Locally", () async {
    // TODO
  });
}
