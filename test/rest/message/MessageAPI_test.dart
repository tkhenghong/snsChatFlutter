import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/general/enums/chat_message_status.dart';
import 'package:snschat_flutter/general/enums/chat_message_type.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

void main() {
  MessageAPIService messageAPIService = MessageAPIService();

  ChatMessage createTestObject() {
    return new ChatMessage(
      id: null,
      conversationId: "5d7cc09dfff90a3328bbb8f9",
      createdTime: new DateTime.now().millisecondsSinceEpoch,
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

  test("Test Create ChatMessage", () async {
    ChatMessage message = createTestObject();
    ChatMessage newMessage = await messageAPIService.addMessage(message);
    print("newMessage.id:" + newMessage.id.toString());
    expect(newMessage.id, isNotEmpty);
  });

  test("Test Edit ChatMessage", () async {
    ChatMessage message = createTestObject();
    ChatMessage newMessage = await messageAPIService.addMessage(message);
    ChatMessage editedMessage = newMessage;
    editedMessage.messageContent = "Testing ChatMessage 2";
    editedMessage.type = ChatMessageType.Video;
    editedMessage.multimediaId = "edited multimedia ID";
    bool edited = await messageAPIService.editMessage(editedMessage);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get ChatMessage", () async {
    ChatMessage message = createTestObject();
    ChatMessage newMessage = await messageAPIService.addMessage(message);
    ChatMessage messageFromServer = await messageAPIService.getSingleMessage(newMessage.id);
    print("messageFromServer.id == newMessage.id:" + (messageFromServer.id == newMessage.id).toString());
    expect(messageFromServer.id == newMessage.id, isTrue);
  });

  test("Test Delete ChatMessage", () async {
    ChatMessage message = createTestObject();
    ChatMessage newMessage = await messageAPIService.addMessage(message);
    print("newMessage.id: "  + newMessage.id);
    bool deleted = await messageAPIService.deleteMessage(newMessage.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get Messages from a Conversation", () async {
    // TODO
  });
}
