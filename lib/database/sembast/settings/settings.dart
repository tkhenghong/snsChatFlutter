import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class SettingsDBService {
  static const String SETTINGS_STORE_NAME = 'settings';

  final StoreRef _settingsStore = intMapStoreFactory.store(SETTINGS_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addSettings(Settings settings) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    int existingSettingsKey = await getSingleSettingsKey(settings.id);
    if (isObjectEmpty(existingSettingsKey)) {
      int key = await _settingsStore.add(await _db, settings.toJson());
      return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
    } else {
      return await editSettings(settings, key: existingSettingsKey);
    }
  }

  Future<bool> editSettings(Settings settings, {int key}) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    if (isObjectEmpty(key)) {
      key = await getSingleSettingsKey(settings.id);
    }

    if (isObjectEmpty(key)) {
      return false;
    }

    Map<String, dynamic> updated = await _settingsStore.record(key).update(await _db, settings.toJson());

    return !isObjectEmpty(updated);
  }

  Future<bool> deleteSettings(String settingsId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals('id', settingsId));

    var noOfDeleted = await _settingsStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllSettings() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    await _settingsStore.delete(await _db);
  }

  Future<Settings> getSingleSettings(String settingsId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', settingsId));
    final recordSnapshot = await _settingsStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? Settings.fromJson(recordSnapshot.value) : null;
  }

  Future<int> getSingleSettingsKey(String settingsId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', settingsId));
    final recordSnapshot = await _settingsStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? recordSnapshot.key : null;
  }

  Future<Settings> getSettingsOfAUser(String userId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('userId', userId));
    final recordSnapshot = await _settingsStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? Settings.fromJson(recordSnapshot.value) : null;
  }

  // Possible usage when doing like Facebook multiple users login
  Future<List<Settings>> getAllSettings() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final recordSnapshots = await _settingsStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<Settings> settingsList = [];
      recordSnapshots.forEach((snapshot) {
        final settings = Settings.fromJson(snapshot.value);
        settingsList.add(settings);
      });

      return settingsList;
    }
    return null;
  }
}
