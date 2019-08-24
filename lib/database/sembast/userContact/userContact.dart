import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

import '../SembastDB.dart';

class UserContactDBService {
  static const String USER_CONTACT_STORE_NAME = "userContact";

  final _userContactStore = intMapStoreFactory.store(USER_CONTACT_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addUserContact(UserContact userContact) async {
    await _userContactStore.add(await _db, userContact.toJson());
  }

  Future editUserContact(UserContact userContact) async {
    final finder = Finder(filter: Filter.equals("id", userContact.id));

    await _userContactStore.update(await _db, userContact.toJson(), finder: finder);
  }

  Future deleteUserContact(String userContactId) async {
    final finder = Finder(filter: Filter.equals("id", userContactId));

    await _userContactStore.delete(await _db, finder: finder);
  }

  Future<UserContact> getSingleUserContact(String userContactId) async {
    final finder = Finder(filter: Filter.equals("id", userContactId));
    final recordSnapshot = await _userContactStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UserContact.fromJson(recordSnapshot.value) : null;
  }

  // Verify userContact is in the local DB or not when login
  Future<UserContact> getUserContactByConversationGroup(String googleAccountId) async {
    final finder = Finder(filter: Filter.equals("googleAccountId", googleAccountId));
    final recordSnapshot = await _userContactStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UserContact.fromJson(recordSnapshot.value) : null;
  }

  // In future, when multiple logins needed
  Future<List<UserContact>> getAllUserContacts() async {
    final recordSnapshots = await _userContactStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UserContact> userContactList = recordSnapshots.map((snapshot) {
        final userContact = UserContact.fromJson(snapshot.value);
        print("userContact.id: " + userContact.id);
        print("snapshot.key: " + snapshot.key.toString());
        userContact.id = snapshot.key.toString();
        return userContact;
      });

      return userContactList;
    }
    return null;
  }
}
