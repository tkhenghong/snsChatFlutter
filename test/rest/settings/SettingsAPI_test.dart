import 'package:flutter_test/flutter_test.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

void main() {
  // SettingsAPIService settingsAPIService = SettingsAPIService();

  Settings createTestObject() {
    return new Settings(
      id: null,
      userId: "seoifhsrekjgrdeg5454",
      allowNotifications: true
    );
  }

  test("Test Get Settingss from a Conversation", () async {
    // TODO
  });
}
