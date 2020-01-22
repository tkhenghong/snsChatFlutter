import 'package:snschat_flutter/backend/rest/unreadMessage/UnreadMessageAPIService.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/unread_message/unread_message.dart';
import 'package:snschat_flutter/objects/unreadMessage/unread_message.dart';

void main() {
  UnreadMessageAPIService unreadMessageAPIService = UnreadMessageAPIService();
  UnreadMessageDBService unreadMessageDBService = UnreadMessageDBService();

  UnreadMessage createTestObject() {
    return new UnreadMessage(
        id: null,
        userId: "r5tf4h5t4h654tsr",
        conversationId: "td54tf564hrsth",
        lastMessage: "568rt4ghrt54hts4rh",
        date: new DateTime.now().millisecondsSinceEpoch,
        count: 99);
  }

  test("Test Create UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();

    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    print("newUnreadMessage.id:" + newUnreadMessage.id.toString());
    await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

    UnreadMessage unreadMessageFromLocalDB = await unreadMessageDBService.getSingleUnreadMessage(newUnreadMessage.id);

    expect(newUnreadMessage.id, isNotEmpty);
    expect(unreadMessageFromLocalDB.id, equals(newUnreadMessage.id));
  });

  test("Test Edit UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();

    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

    UnreadMessage editedUnreadMessage = newUnreadMessage;
    editedUnreadMessage.userId = "999999999";
    editedUnreadMessage.conversationId = "88888888";
    editedUnreadMessage.lastMessage = "Edited Last Message";
    editedUnreadMessage.date = 111111111;

    bool edited = await unreadMessageAPIService.editUnreadMessage(editedUnreadMessage);
    print("edited:" + edited.toString());
    await unreadMessageDBService.editUnreadMessage(editedUnreadMessage);
    UnreadMessage unreadMessageFromLocalDB = await unreadMessageDBService.getSingleUnreadMessage(newUnreadMessage.id);

    expect(unreadMessageFromLocalDB.id, equals(editedUnreadMessage.id));
    expect(unreadMessageFromLocalDB.userId, equals(editedUnreadMessage.userId));
    expect(unreadMessageFromLocalDB.conversationId, equals(editedUnreadMessage.conversationId));
    expect(unreadMessageFromLocalDB.lastMessage, equals(editedUnreadMessage.lastMessage));
    expect(unreadMessageFromLocalDB.date, equals(editedUnreadMessage.date));
    expect(edited, isTrue);
  });

  test("Test Get UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();

    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

    UnreadMessage unreadMessageFromServer = await unreadMessageAPIService.getSingleUnreadMessage(newUnreadMessage.id);
    UnreadMessage unreadMessageFromLocalDB = await unreadMessageDBService.getSingleUnreadMessage(newUnreadMessage.id);

    expect(unreadMessageFromServer.id, equals(newUnreadMessage.id));
    expect(unreadMessageFromLocalDB.id, equals(unreadMessageFromServer.id));
  });

  test("Test Delete UnreadMessage Locally", () async {
    UnreadMessage unreadMessage = createTestObject();

    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);
    await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

    bool deleted = await unreadMessageAPIService.deleteUnreadMessage(newUnreadMessage.id);
    await unreadMessageDBService.deleteUnreadMessage(unreadMessage.id);

    expect(deleted, isTrue);
    expect(await unreadMessageDBService.getSingleUnreadMessage(unreadMessage.id), null);
  });

  test("Test Get UnreadMessages from a Conversation Locally", () async {
    // TODO
  });
}
