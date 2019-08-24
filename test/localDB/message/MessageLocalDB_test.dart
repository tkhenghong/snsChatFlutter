import 'package:snschat_flutter/backend/rest/message/MessageAPIService.dart';
import 'package:snschat_flutter/database/sembast/message/message.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/message/message.dart';

void main() {
  MessageAPIService messageAPIService = MessageAPIService();
  MessageDBService messageDBService = MessageDBService();

  Message createTestObject() {
    return new Message(
      id: null,
      conversationId: "wadhawidafgrs",
      timestamp: "seiughrsiughrisdg",
      messageContent: "bla bla bla",
      type: "Message",
      status: "READ",
      senderName: "Teoh Kheng Hong",
      senderMobileNo: "+60182262663",
      senderId: "f9g87rd98g7r8e9g7",
      receiverName: "Teoh Kheng Lam",
      receiverMobileNo: "+60182223991",
      receiverId: "df09g809dg8df0",
      multimediaId: "seioghsriujgrsogr78gf9rg78",
    );
  }

  test("Test Create Message Locally", () async {
    Message message = createTestObject();

    Message newMessage = await messageAPIService.addMessage(message);
    print("newMessage.id:" + newMessage.id.toString());
    await messageDBService.addMessage(newMessage);
    Message messageFromLocalDB = await messageDBService.getSingleMessage(newMessage.id);

    expect(newMessage.id, isNotEmpty);
    expect(messageFromLocalDB.id, equals(newMessage.id));
  });

  test("Test Edit Message Locally", () async {
    Message message = createTestObject();

    Message newMessage = await messageAPIService.addMessage(message);
    await messageDBService.addMessage(newMessage);

    Message editedMessage = newMessage;
    editedMessage.messageContent = "Testing Message 2";
    editedMessage.type = "Video";
    editedMessage.multimediaId = "edited multimedia ID";

    bool edited = await messageAPIService.editMessage(editedMessage);
    print("edited:" + edited.toString());
    await messageDBService.editMessage(editedMessage);
    Message messageFromLocalDB = await messageDBService.getSingleMessage(newMessage.id);

    expect(messageFromLocalDB.id, equals(messageFromLocalDB.id));
    expect(messageFromLocalDB.messageContent, equals(messageFromLocalDB.messageContent));
    expect(messageFromLocalDB.type, equals(messageFromLocalDB.type));
    expect(messageFromLocalDB.multimediaId, equals(messageFromLocalDB.multimediaId));
    expect(edited, isTrue);
  });

  test("Test Get Message Locally", () async {
    Message message = createTestObject();

    Message newMessage = await messageAPIService.addMessage(message);
    await messageDBService.addMessage(newMessage);

    Message messageFromServer = await messageAPIService.getSingleMessage(newMessage.id);
    Message messageFromLocalDB = await messageDBService.getSingleMessage(message.id);

    expect(messageFromServer.id, equals(newMessage.id));
    expect(messageFromLocalDB.id, equals(messageFromServer.id));
  });

  test("Test Delete Message Locally", () async {
    Message message = createTestObject();

    Message newMessage = await messageAPIService.addMessage(message);
    print("newMessage.id: " + newMessage.id);
    await messageDBService.addMessage(newMessage);

    bool deleted = await messageAPIService.deleteMessage(newMessage.id);
    await messageDBService.deleteMessage(message.id);
    print("deleted:" + deleted.toString());

    expect(deleted, isTrue);
    expect(await messageDBService.getSingleMessage(message.id), null);
  });

  test("Test Get Messages from a Conversation Locally", () async {
    // TODO
  });
}
