import 'package:snschat_flutter/backend/rest/unreadMessage/UnreadMessageAPIService.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';

void main() {
  UnreadMessageAPIService unreadMessageAPIService = UnreadMessageAPIService();

  UnreadMessage createTestObject() {
    return new UnreadMessage(
        id: null,
        userId: "r5tf4h5t4h654tsr",
        conversationId: "td54tf564hrsth",
        lastMessage: "568rt4ghrt54hts4rh",
        date: 654156874,
        count: 99);
  }

  test("Test Create UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    print("newUnreadMessage.id:" + newUnreadMessage.id.toString());
    expect(newUnreadMessage.id, isNotEmpty);
  });

  test("Test Edit UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    UnreadMessage editedUnreadMessage = newUnreadMessage;
    editedUnreadMessage.userId = "999999999";
    editedUnreadMessage.conversationId = "88888888";
    editedUnreadMessage.lastMessage = "Edited Last Message";
    editedUnreadMessage.date = 111111111;
    bool edited = await unreadMessageAPIService.editUnreadMessage(editedUnreadMessage);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    UnreadMessage unreadMessageFromServer = await unreadMessageAPIService.getSingleUnreadMessage(newUnreadMessage.id);
    print("unreadMessageFromServer.id == newUnreadMessage.id:" + (unreadMessageFromServer.id == newUnreadMessage.id).toString());
    expect(unreadMessageFromServer.id == newUnreadMessage.id, isTrue);
  });

  test("Test Delete UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    print("newUnreadMessage.id: " + newUnreadMessage.id);
    bool deleted = await unreadMessageAPIService.deleteUnreadMessage(newUnreadMessage.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get UnreadMessages from a Conversation Locally", () async {
    // TODO
  });
}
