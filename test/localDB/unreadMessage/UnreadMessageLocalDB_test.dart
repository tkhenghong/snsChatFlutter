import 'package:flutter_test/flutter_test.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

void main() {
  UnreadMessageAPIService unreadMessageAPIService = UnreadMessageAPIService();
  UnreadMessageDBService unreadMessageDBService = UnreadMessageDBService();

  // UnreadMessage createTestObject() {
  //   return new UnreadMessage(
  //       id: null,
  //       userId: "r5tf4h5t4h654tsr",
  //       conversationId: "td54tf564hrsth",
  //       lastMessage: "568rt4ghrt54hts4rh",
  //       date: new DateTime.now(),
  //       count: 99);
  // }

  test("Test Get UnreadMessages from a Conversation Locally", () async {
    // TODO
  });
}
