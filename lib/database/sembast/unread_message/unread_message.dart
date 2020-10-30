import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class UnreadMessageDBService {
  static const String UNREADMESSAGE_STORE_NAME = "unreadMessage";

  final _unreadMessageStore = intMapStoreFactory.store(UNREADMESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  /// Add single unread message.
  Future<bool> addUnreadMessage(UnreadMessage unreadMessage) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    UnreadMessage existingUnreadMessage = await getSingleUnreadMessage(unreadMessage.id);
    if (isObjectEmpty(existingUnreadMessage)) {
      int key = await _unreadMessageStore.add(await _db, unreadMessage.toJson());
      return key != null && key != 0 && key.toString().isNotEmpty;
    } else {
      return await editUnreadMessage(unreadMessage);
    }
  }

  /// Add unread message in batch, with transaction safety.
  Future<void> addUnreadMessages(List<UnreadMessage> unreadMessages) async {
    Database database = await _db;
    if (isObjectEmpty(database)) {
      return false;
    }

    try {
      await database.transaction((transaction) async {
        for (int i = 0; i < unreadMessages.length; i++) {
          UnreadMessage existingUnreadMessage = await getSingleUnreadMessage(unreadMessages[i].id);
          isObjectEmpty(existingUnreadMessage) ? await _unreadMessageStore.add(database, unreadMessages[i].toJson()) : editUnreadMessage(unreadMessages[i]);
        }
      });
      return true;
    } catch (e) {
      // Error happened in database transaction.
      return false;
    }
  }

  Future<bool> editUnreadMessage(UnreadMessage unreadMessage) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", unreadMessage.id));

    var noOfUpdated = await _unreadMessageStore.update(await _db, unreadMessage.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteUnreadMessage(String unreadMessageId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", unreadMessageId));

    var noOfDeleted = await _unreadMessageStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllUnreadMessage() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    _unreadMessageStore.delete(await _db);
  }

  Future<UnreadMessage> getSingleUnreadMessage(String unreadMessageId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", unreadMessageId));
    final recordSnapshot = await _unreadMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UnreadMessage.fromJson(recordSnapshot.value) : null;
  }

  /// Find multiple UnreadMessage objects using a list of unreadMessageIds.
  Future<List<UnreadMessage>> getUnreadMessages(List<String> unreadMessageIds) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }

    final finder = Finder(filter: Filter.inList('id', unreadMessageIds));
    final recordSnapshots = await _unreadMessageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UnreadMessage> unreadMessageList = [];
      recordSnapshots.forEach((snapshot) {
        final unreadMessage = UnreadMessage.fromJson(snapshot.value);
        unreadMessageList.add(unreadMessage);
      });

      return unreadMessageList;
    }
    return [];
  }

  Future<UnreadMessage> getUnreadMessageOfAConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshot = await _unreadMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UnreadMessage.fromJson(recordSnapshot.value) : null;
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
    return [];
  }

  /// Load UnreadMessage objects with given pagination.
  /// Probably not needed due to complex situation(May not in sync with Conversation Group objects)
  Future<List<UnreadMessage>> getAllUnreadMessagesWithPagination(int page, int size) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    // Auto sort by lastModifiedDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('lastModifiedDate', false)], offset: page * size, limit: size);
    final recordSnapshots = await _unreadMessageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UnreadMessage> unreadMessageList = [];
      recordSnapshots.forEach((snapshot) {
        final unreadMessage = UnreadMessage.fromJson(snapshot.value);
        unreadMessageList.add(unreadMessage);
      });

      return unreadMessageList;
    }
    return [];
  }
}
