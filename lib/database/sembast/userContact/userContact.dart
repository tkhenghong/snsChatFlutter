import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

import '../SembastDB.dart';

class UserContactDBService {
  static const String USER_CONTACT_STORE_NAME = "userContact";

  final _userContactStore = intMapStoreFactory.store(USER_CONTACT_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addUserContact(UserContact userContact) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    UserContact existingUserContact = await getSingleUserContact(userContact.id);
    var key = existingUserContact == null ? await _userContactStore.add(await _db, userContact.toJson()) : null;

    return !isStringEmpty(key.toString());
  }

  Future<bool> editUserContact(UserContact userContact) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", userContact.id));

    var noOfUpdated = await _userContactStore.update(await _db, userContact.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteUserContact(String userContactId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", userContactId));

    var noOfDeleted = await _userContactStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<UserContact> getSingleUserContact(String userContactId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", userContactId));
    final recordSnapshot = await _userContactStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UserContact.fromJson(recordSnapshot.value) : null;
  }

  // Verify userContact is in the local DB or not when login
  Future<UserContact> getUserContactByConversationGroup(String googleAccountId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("googleAccountId", googleAccountId));
    final recordSnapshot = await _userContactStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UserContact.fromJson(recordSnapshot.value) : null;
  }

  Future<UserContact> getUserContactByMobileNo(String mobileNo) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("mobileNo", mobileNo));
    final recordSnapshot = await _userContactStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UserContact.fromJson(recordSnapshot.value) : null;
  }

  // In future, when multiple logins needed
  Future<List<UserContact>> getAllUserContacts() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final recordSnapshots = await _userContactStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UserContact> userContactList = [];
      recordSnapshots.forEach((snapshot) {
        final userContact = UserContact.fromJson(snapshot.value);
        print("userContact.id: " + userContact.id);
        print("snapshot.key: " + snapshot.key.toString());
        userContact.id = snapshot.key.toString();
        userContactList.add(userContact);
      });

      return userContactList;
    }
    return null;
  }
}
