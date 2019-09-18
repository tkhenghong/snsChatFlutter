import 'package:snschat_flutter/backend/rest/message/MessageAPIService.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/message/message.dart';

void main() {
  MessageAPIService messageAPIService = MessageAPIService();

  Message createTestObject() {
    return new Message(
      id: null,
      conversationId: "5d7cc09dfff90a3328bbb8f9",
      timestamp: new DateTime.now().millisecondsSinceEpoch,
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

  test("Test Create Message", () async {
    Message message = createTestObject();
    Message newMessage = await messageAPIService.addMessage(message);
    print("newMessage.id:" + newMessage.id.toString());
    expect(newMessage.id, isNotEmpty);
  });

  test("Test Edit Message", () async {
    Message message = createTestObject();
    Message newMessage = await messageAPIService.addMessage(message);
    Message editedMessage = newMessage;
    editedMessage.messageContent = "Testing Message 2";
    editedMessage.type = "Video";
    editedMessage.multimediaId = "edited multimedia ID";
    bool edited = await messageAPIService.editMessage(editedMessage);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get Message", () async {
    Message message = createTestObject();
    Message newMessage = await messageAPIService.addMessage(message);
    Message messageFromServer = await messageAPIService.getSingleMessage(newMessage.id);
    print("messageFromServer.id == newMessage.id:" + (messageFromServer.id == newMessage.id).toString());
    expect(messageFromServer.id == newMessage.id, isTrue);
  });

  test("Test Delete Message", () async {
    Message message = createTestObject();
    Message newMessage = await messageAPIService.addMessage(message);
    print("newMessage.id: "  + newMessage.id);
    bool deleted = await messageAPIService.deleteMessage(newMessage.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get Messages from a Conversation", () async {
    // TODO
  });
}
