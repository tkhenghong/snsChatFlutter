import 'package:snschat_flutter/backend/rest/settings/SettingsAPIService.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';

void main() {
//  SettingsAPIService settingsAPIService = SettingsAPIService();

  Settings createTestObject() {
    return new Settings(
      id: null,
      userId: "seoifhsrekjgrdeg5454",
      notification: true
    );
  }

  test("Test Create Settings", () async {
    Settings settings = createTestObject();
    Settings newSettings = await settingsAPIService.addSettings(settings);
    print("newSettings.id:" + newSettings.id.toString());
    expect(newSettings.id, isNotEmpty);
  });

  test("Test Edit Settings", () async {
    Settings settings = createTestObject();
    Settings newSettings = await settingsAPIService.addSettings(settings);
    Settings editedSettings = newSettings;
    editedSettings.userId = "Edited userId";
    editedSettings.notification = false;
    bool edited = await settingsAPIService.editSettings(editedSettings);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get Settings", () async {
    Settings settings = createTestObject();
    Settings newSettings = await settingsAPIService.addSettings(settings);
    Settings settingsFromServer = await settingsAPIService.getSingleSettings(newSettings.id);
    print("settingsFromServer.id == newSettings.id:" + (settingsFromServer.id == newSettings.id).toString());
    expect(settingsFromServer.id == newSettings.id, isTrue);
  });

  test("Test Delete Settings", () async {
    Settings settings = createTestObject();
    Settings newSettings = await settingsAPIService.addSettings(settings);
    print("newSettings.id: "  + newSettings.id);
    bool deleted = await settingsAPIService.deleteSettings(newSettings.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get Settingss from a Conversation", () async {
    // TODO
  });
}
