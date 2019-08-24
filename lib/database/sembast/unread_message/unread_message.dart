import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';

import '../SembastDB.dart';

class UnreadMessageDBService {
  static const String UNREADMESSAGE_STORE_NAME = "unreadMessage";

  final _unreadMessageStore = intMapStoreFactory.store(UNREADMESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addUnreadMessage(UnreadMessage unreadMessage) async {
    await _unreadMessageStore.add(await _db, unreadMessage.toJson());
  }

  Future editUnreadMessage(UnreadMessage unreadMessage) async {
    final finder = Finder(filter: Filter.equals("id", unreadMessage.id));

    await _unreadMessageStore.update(await _db, unreadMessage.toJson(), finder: finder);
  }

  Future deleteUnreadMessage(String unreadMessageId) async {
    final finder = Finder(filter: Filter.equals("id", unreadMessageId));

    await _unreadMessageStore.delete(await _db, finder: finder);
  }

  Future<UnreadMessage> getSingleUnreadMessage(String unreadMessageId) async {
    final finder = Finder(filter: Filter.equals("id", unreadMessageId));
    final recordSnapshot = await _unreadMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UnreadMessage.fromJson(recordSnapshot.value) : null;
  }

  Future<UnreadMessage> getUnreadMessageOfAConversationGroup(String conversationGroupId) async {
    final finder = Finder(filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshot = await _unreadMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? UnreadMessage.fromJson(recordSnapshot.value) : null;
  }

  Future<List<UnreadMessage>> getAllUnreadMessage() async {
    final recordSnapshots = await _unreadMessageStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<UnreadMessage> unreadMessageList = recordSnapshots.map((snapshot) {
        final unreadMessage = UnreadMessage.fromJson(snapshot.value);
        print("unreadMessage.id: " + unreadMessage.id);
        print("snapshot.key: " + snapshot.key.toString());
        unreadMessage.id = snapshot.key.toString();
        return unreadMessage;
      });

      return unreadMessageList;
    }
    return null;
  }
}
