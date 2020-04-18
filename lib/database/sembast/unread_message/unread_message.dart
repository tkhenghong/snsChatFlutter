import 'package:sembast/sembast.dart';

import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/index.dart';
import '../SembastDB.dart';

class UnreadMessageDBService {
  static const String UNREADMESSAGE_STORE_NAME = "unreadMessage";

  final _unreadMessageStore =
      intMapStoreFactory.store(UNREADMESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addUnreadMessage(UnreadMessage unreadMessage) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    UnreadMessage existingUnreadMessage =
        await getSingleUnreadMessage(unreadMessage.id);
    var key = isObjectEmpty(existingUnreadMessage)
        ? await _unreadMessageStore.add(await _db, unreadMessage.toJson())
        : null;

    return !isStringEmpty(key.toString());
  }

  Future<bool> editUnreadMessage(UnreadMessage unreadMessage) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", unreadMessage.id));

    var noOfUpdated = await _unreadMessageStore
        .update(await _db, unreadMessage.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteUnreadMessage(String unreadMessageId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", unreadMessageId));

    var noOfDeleted =
        await _unreadMessageStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<UnreadMessage> getSingleUnreadMessage(String unreadMessageId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", unreadMessageId));
    final recordSnapshot =
        await _unreadMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot)
        ? UnreadMessage.fromJson(recordSnapshot.value)
        : null;
  }

  Future<UnreadMessage> getUnreadMessageOfAConversationGroup(
      String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(
        filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshot =
        await _unreadMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot)
        ? UnreadMessage.fromJson(recordSnapshot.value)
        : null;
  }

  Future<List<UnreadMessage>> getAllUnreadMessage() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final recordSnapshots = await _unreadMessageStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UnreadMessage> unreadMessageList = [];
      recordSnapshots.forEach((snapshot) {
        final unreadMessage = UnreadMessage.fromJson(snapshot.value);
        unreadMessageList.add(unreadMessage);
      });

      return unreadMessageList;
    }
    return null;
  }
}
