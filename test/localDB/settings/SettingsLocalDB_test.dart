import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:uuid/uuid.dart';

void main() {
  SettingsDBService settingsDBService = new SettingsDBService();

  var uuid = Uuid();

  Settings createTestObject() {
    Settings settings = Settings(
      id: uuid.v4(),
      userId: uuid.v4(),
      allowNotifications: true,
    );
    settings.createdBy = uuid.v4();
    settings.createdDate = DateTime.now();
    settings.lastModifiedBy = uuid.v4();
    settings.lastModifiedDate = DateTime.now();
    settings.version = 1;
    return settings;
  }

  wipeAllSettings() async {
    await settingsDBService.deleteAllSettings();
  }

  test('Create Settings', () async {
    await wipeAllSettings();
    Settings settings = createTestObject();

    // Add
    bool added = await settingsDBService.addSettings(settings);

    // Get
    Settings settingsFromLocalDB = await settingsDBService.getSingleSettings(settings.id);

    // Validations
    expect(added, isTrue);
    expect(settingsFromLocalDB, isNotNull);
    expect(settingsFromLocalDB.id, isNotNull);
    expect(settingsFromLocalDB.id, equals(settings.id)); // Only comparing IDs due to no equatable package
  });

  // NOTE: Asynchronous saving the same thing into DB
  // Answer: You will not even getting the database even after delayed for 5 seconds after you have saved the same conversation group twice into DB.
  test('Create Settings Asynchronously', () async {
    await wipeAllSettings();
    Settings settings = createTestObject();

    // Add
    settingsDBService.addSettings(settings);

    // Edit
    settings.allowNotifications = false;

    // Add
    settingsDBService.addSettings(settings);

    Settings settingsFromLocalDB = await settingsDBService.getSingleSettings(settings.id);

    // Validations
    expect(settingsFromLocalDB, isNull);
  });

  test('Create and Edit Settings', () async {
    await wipeAllSettings();

    Settings settings = createTestObject();

    // Add
    bool added;
    try {
      added = await settingsDBService.addSettings(settings);
    } catch (e) {
      print('Create and Edit Settings failed. e: $e');
      added = false;
    }

    // Get
    Settings settingsFromLocalDB = await settingsDBService.getSingleSettings(settings.id);

    // Edit
    settings.allowNotifications = false;

    // Edit in DB
    bool edited = await settingsDBService.editSettings(settings);
    Settings editedSettings = await settingsDBService.getSingleSettings(settings.id);

    // Validations
    expect(added, isTrue);
    expect(edited, isTrue);
    expect(settingsFromLocalDB, isNotNull);
    expect(editedSettings.id, isNotNull);
    expect(editedSettings.id, equals(settingsFromLocalDB.id));
    expect(editedSettings.allowNotifications, isNotNull);
  });

  test('Test Save Settings Multiple Times', () async {
    await wipeAllSettings();
    Settings settings = createTestObject();
    int noOfSaves = 50;

    bool added = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      try {
        bool added2 = await settingsDBService.addSettings(settings);
        // If one save is now saved successfully, the added variable will be false.
        if (!added2) {
          added = false;
        }
      } catch (e) {
        print('Save Settings multiple times failed. e: $e');
        added = false;
      }
    }

    // Get
    List<Settings> settingsList = await settingsDBService.getAllSettings();

    expect(added, isTrue);
    expect(settingsList.length, equals(1));
  });

  test('Test Delete Single Settings', () async {
    await wipeAllSettings();
    Settings settings = createTestObject();

    // Add
    bool added = await settingsDBService.addSettings(settings);

    // Delete
    bool deleted = await settingsDBService.deleteSettings(settings.id);

    // Get
    Settings settingsFromLocalDB = await settingsDBService.getSingleSettings(settings.id);

    expect(added, isTrue);
    expect(deleted, isTrue);
    expect(settingsFromLocalDB, null);
  });

  test('Test Wipe All Settings', () async {
    await wipeAllSettings();

    // Get
    List<Settings> settings = await settingsDBService.getAllSettings();

    expect(settings, equals([]));
    expect(settings.length, equals(0));
  });

  /// A test of loading conversation groups with pagination to test offline capability of the app when network is not available.
  /// A sample of noOfSaves of records will be save into Database. Then load first page of records and check the first element of the result.
  test('Test Settings with Pagination', () async {
    await wipeAllSettings();

    // Set up
    List<Settings> allSettings = [];

    String randomUserId = uuid.v4();

    int noOfSaves = 50;

    int numberOfPages = 5;

    int paginationSize = 10;

    expect(numberOfPages * paginationSize, equals(noOfSaves));

    bool allSavedSuccess = true;

    // Add
    for (int i = 0; i < noOfSaves; i++) {
      Settings settings = createTestObject();

      if (i == 25) {
        settings.userId = randomUserId;
      }

      allSettings.add(settings);

      bool added = await settingsDBService.addSettings(settings);

      if (!added) {
        allSavedSuccess = false;
      }
    }

    expect(allSavedSuccess, isTrue);

    // Get
    Settings randomUserIdSettings = await settingsDBService.getSettingsOfAUser(randomUserId);

    expect(randomUserIdSettings, isNotNull);
    expect(randomUserIdSettings.userId, equals(randomUserId));
  });
}
