import 'package:snschat_flutter/backend/rest/settings/SettingsAPIService.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/settings/settings.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';

void main() {
  SettingsAPIService settingsAPIService = SettingsAPIService();
  SettingsDBService settingsDBService = SettingsDBService();

  Settings createTestObject() {
    return new Settings(id: null, userId: "seoifhsrekjgrdeg5454", notification: true);
  }

  test("Test Create Settings Locally", () async {
    Settings settings = createTestObject();

    Settings newSettings = await settingsAPIService.addSettings(settings);

    print("newSettings.id:" + newSettings.id.toString());
    await settingsDBService.addSettings(newSettings);

    Settings settingsFromLocalDB = await settingsDBService.getSingleSettings(newSettings.id);

    expect(newSettings.id, isNotEmpty);
    expect(settingsFromLocalDB.id, equals(newSettings.id));
  });

  test("Test Edit Settings Locally", () async {
    Settings settings = createTestObject();

    Settings newSettings = await settingsAPIService.addSettings(settings);
    await settingsDBService.addSettings(newSettings);

    Settings editedSettings = newSettings;
    editedSettings.userId = "Edited userId";
    editedSettings.notification = false;

    bool edited = await settingsAPIService.editSettings(editedSettings);
    print("edited:" + edited.toString());
    await settingsDBService.editSettings(editedSettings);
    Settings settingsFromLocalDB = await settingsDBService.getSingleSettings(newSettings.id);

    expect(settingsFromLocalDB.id, equals(editedSettings.id));
    expect(settingsFromLocalDB.userId, equals(editedSettings.userId));
    expect(settingsFromLocalDB.notification, equals(editedSettings.notification));
    expect(edited, isTrue);
  });

  test("Test Get Settings Locally", () async {
    Settings settings = createTestObject();

    Settings newSettings = await settingsAPIService.addSettings(settings);
    await settingsDBService.addSettings(newSettings);

    Settings settingsFromServer = await settingsAPIService.getSingleSettings(newSettings.id);
    Settings settingsFromLocalDB = await settingsDBService.getSingleSettings(newSettings.id);

    expect(settingsFromServer.id, equals(newSettings.id));
    expect(settingsFromLocalDB.id, equals(settingsFromServer.id));
  });

  test("Test Delete Settings Locally", () async {
    Settings settings = createTestObject();

    Settings newSettings = await settingsAPIService.addSettings(settings);
    await settingsDBService.addSettings(newSettings);

    bool deleted = await settingsAPIService.deleteSettings(settings.id);
    await settingsDBService.deleteSettings(settings.id);

    expect(deleted, isTrue);
    expect(await settingsDBService.getSingleSettings(settings.id), null);
  });

  test("Test Get Settingss from a Conversation Locally", () async {
    // TODO
  });
}
