import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';

import '../SembastDB.dart';

class SettingsDBService {
  static const String SETTINGS_STORE_NAME = "settings";

  final _settingsStore = intMapStoreFactory.store(SETTINGS_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addSettings(Settings settings) async {
    await _settingsStore.add(await _db, settings.toJson());
  }

  Future editSettings(Settings settings) async {
    final finder = Finder(filter: Filter.equals("id", settings.id));

    await _settingsStore.update(await _db, settings.toJson(), finder: finder);
  }

  Future deleteSettings(String settingsId) async {
    final finder = Finder(filter: Filter.equals("id", settingsId));

    await _settingsStore.delete(await _db, finder: finder);
  }

  Future<Settings> getSingleSettings(String settingsId) async {
    final finder = Finder(filter: Filter.equals("id", settingsId));
    final recordSnapshot = await _settingsStore.findFirst(await _db, finder: finder);

    return recordSnapshot.value.isNotEmpty ? Settings.fromJson(recordSnapshot.value) : null;
  }

  Future<Settings> getSettingsOfAUser(String userId) async {
    final finder = Finder(filter: Filter.equals("userId", userId));
    final recordSnapshot = await _settingsStore.findFirst(await _db, finder: finder);

    return recordSnapshot.value.isNotEmpty ? Settings.fromJson(recordSnapshot.value) : null;
  }

  // Possible usage when doing like Facebook multiple users login
  Future<List<Settings>> getAllSettings() async {
    final recordSnapshots = await _settingsStore.find(await _db);
    List<Settings> settingsList = recordSnapshots.map((snapshot) {
      final settings = Settings.fromJson(snapshot.value);
      print("settings.id: " + settings.id);
      print("snapshot.key: " +
          snapshot.key.toString());
      settings.id = snapshot.key.toString();
      return settings;
    });

    return settingsList;
  }
}