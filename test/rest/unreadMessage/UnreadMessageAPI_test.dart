import 'package:snschat_flutter/rest/index.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/index.dart';

void main() {
  UnreadMessageAPIService unreadMessageAPIService = UnreadMessageAPIService();

  UnreadMessage createTestObject() {
    return new UnreadMessage(
        id: null,
        userId: "r5tf4h5t4h654tsr",
        conversationId: "td54tf564hrsth",
        lastMessage: "568rt4ghrt54hts4rh",
        date: new DateTime.now().millisecondsSinceEpoch,
        count: 99);
  }

  test("Test Create UnreadMessage", () async {
    UnreadMessage unreadMessage = createTestObject();
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    print("newUnreadMessage.id:" + newUnreadMessage.id.toString());
    expect(newUnreadMessage.id, isNotEmpty);
  });

  test("Test Edit UnreadMessage", () async {
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

  test("Test Get UnreadMessage", () async {
    UnreadMessage unreadMessage = createTestObject();
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    UnreadMessage unreadMessageFromServer = await unreadMessageAPIService.getSingleUnreadMessage(newUnreadMessage.id);
    print("unreadMessageFromServer.id == newUnreadMessage.id:" + (unreadMessageFromServer.id == newUnreadMessage.id).toString());
    expect(unreadMessageFromServer.id == newUnreadMessage.id, isTrue);
  });

  test("Test Delete UnreadMessage", () async {
    UnreadMessage unreadMessage = createTestObject();
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    print("newUnreadMessage.id: " + newUnreadMessage.id);
    bool deleted = await unreadMessageAPIService.deleteUnreadMessage(newUnreadMessage.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get UnreadMessages from a Conversation", () async {
    // TODO
  });
}
