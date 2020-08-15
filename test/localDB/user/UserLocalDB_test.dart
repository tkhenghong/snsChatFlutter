import 'package:flutter_test/flutter_test.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

void main() {
  UserAPIService userAPIService = UserAPIService();
  UserDBService userDBService = UserDBService();

  User createTestObject() {
    return new User(
        id: null, mobileNo: "0182262663", displayName: "Teoh Kheng Hong", googleAccountId: "88888888", realName: "A.W.P G.H.O.S.T");
  }
}
