import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class SettingsDBService {
  static const String SETTINGS_STORE_NAME = "settings";

  final _settingsStore = intMapStoreFactory.store(SETTINGS_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addSettings(Settings settings) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    Settings existingSettings = await getSingleSettings(settings.id);
    var key = existingSettings == null ? await _settingsStore.add(await _db, settings.toJson()) : editSettings(settings);

    return !isStringEmpty(key.toString());
  }

  Future<bool> editSettings(Settings settings) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", settings.id));

    var noOfUpdated = await _settingsStore.update(await _db, settings.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteSettings(String settingsId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", settingsId));

    var noOfDeleted = await _settingsStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllSettings() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    _settingsStore.delete(await _db);
  }

  Future<Settings> getSingleSettings(String settingsId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", settingsId));
    final recordSnapshot = await _settingsStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? Settings.fromJson(recordSnapshot.value) : null;
  }

  Future<Settings> getSettingsOfAUser(String userId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("userId", userId));
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
