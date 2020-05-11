import 'package:sembast/sembast.dart';

import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import '../SembastDB.dart';

class UserDBService {
  static const String USER_STORE_NAME = "user";

  final _userStore = intMapStoreFactory.store(USER_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addUser(User user) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    User existingUser = await getSingleUser(user.id);
    var key = isObjectEmpty(existingUser)
        ? await _userStore.add(await _db, user.toJson())
        : null;

    return !isStringEmpty(key.toString());
  }

  Future<bool> editUser(User user) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", user.id));

    var noOfUpdated =
        await _userStore.update(await _db, user.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteUser(String userId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", userId));

    var noOfDeleted = await _userStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<User> getSingleUser(String userId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", userId));
    final recordSnapshot =
        await _userStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot)
        ? User.fromJson(recordSnapshot.value)
        : null;
  }

  // Verify user is in the local DB or not when login
  Future<User> getUserByGoogleAccountId(String googleAccountId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder =
        Finder(filter: Filter.equals("googleAccountId", googleAccountId));
    final recordSnapshot =
        await _userStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot)
        ? User.fromJson(recordSnapshot.value)
        : null;
  }

  // In future, when multiple logins needed
  Future<List<User>> getAllUsers() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final recordSnapshots = await _userStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<User> userList = [];
      recordSnapshots.forEach((snapshot) {
        final user = User.fromJson(snapshot.value);
        userList.add(user);
      });

      return userList;
    }
    return null;
  }
}
