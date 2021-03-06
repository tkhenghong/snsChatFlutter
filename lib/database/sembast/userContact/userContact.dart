import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class UserContactDBService {
  static const String USER_CONTACT_STORE_NAME = "userContact";

  final StoreRef _userContactStore = intMapStoreFactory.store(USER_CONTACT_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  /// Add single user contact.
  Future<bool> addUserContact(UserContact userContact) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    int existingUserContactKey = await getSingleUserContactKey(userContact.id);
    if (isObjectEmpty(existingUserContactKey)) {
      int key = await _userContactStore.add(await _db, userContact.toJson());
      return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
    } else {
      return await editUserContact(userContact, key: existingUserContactKey);
    }
  }

  /// Add user contact in batch, with transaction safety.
  Future<void> addUserContacts(List<UserContact> userContacts) async {
    Database database = await _db;
    if (isObjectEmpty(database)) {
      return false;
    }

    try {
      await database.transaction((transaction) async {
        for (int i = 0; i < userContacts.length; i++) {
          int existingUserContactKey = await getSingleUserContactKey(userContacts[i].id);
          isObjectEmpty(existingUserContactKey) ? await _userContactStore.add(database, userContacts[i].toJson()) : editUserContact(userContacts[i], key: existingUserContactKey);
        }
      });
      return true;
    } catch (e) {
      print('SembastDB User Contact addUserContacts() Error: $e');
      // Error happened in database transaction.
      return false;
    }
  }

  Future<bool> editUserContact(UserContact userContact, {int key}) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    if (isObjectEmpty(key)) {
      key = await getSingleUserContactKey(userContact.id);
    }

    if (isObjectEmpty(key)) {
      return false;
    }

    Map<String, dynamic> updated = await _userContactStore.record(key).update(await _db, userContact.toJson());

    return !isObjectEmpty(updated);
  }

  Future<bool> deleteUserContact(String userContactId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", userContactId));

    var noOfDeleted = await _userContactStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllUserContacts() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    await _userContactStore.delete(await _db);
  }

  Future<UserContact> getSingleUserContact(String userContactId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", userContactId));
    final recordSnapshot = await _userContactStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UserContact.fromJson(recordSnapshot.value) : null;
  }

  Future<int> getSingleUserContactKey(String userContactId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', userContactId));
    final recordSnapshot = await _userContactStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? recordSnapshot.key : null;
  }

  Future<UserContact> getUserContactByUserId(String userId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("userId", userId));
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

  Future<List<UserContact>> getAllUserContacts() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final recordSnapshots = await _userContactStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UserContact> userContactList = [];
      recordSnapshots.forEach((snapshot) {
        final userContact = UserContact.fromJson(snapshot.value);
        userContactList.add(userContact);
      });

      return userContactList;
    }
    return [];
  }

  /// Conversation group user contacts don't have pagination because the full list is in Conversation Group object already.
  Future<List<UserContact>> getConversationGroupUserContacts(List<String> userContactIds) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    // Auto sort by lastModifiedDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('lastModifiedDate', false)], filter: Filter.inList('id', userContactIds));
    final recordSnapshots = await _userContactStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UserContact> userContactList = [];
      recordSnapshots.forEach((snapshot) {
        final userContact = UserContact.fromJson(snapshot.value);
        userContactList.add(userContact);
      });

      return userContactList;
    }
    return [];
  }

  Future<List<UserContact>> getAllUserContactsWithPagination(int page, int size) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    // Auto sort by lastModifiedDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('lastModifiedDate', false)], offset: page * size, limit: size);
    final recordSnapshots = await _userContactStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UserContact> userContactList = [];
      recordSnapshots.forEach((snapshot) {
        final userContact = UserContact.fromJson(snapshot.value);
        userContactList.add(userContact);
      });

      return userContactList;
    }
    return [];
  }
}
