import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class ConversationDBService {
  // Same like mongoDB, this setups what the collection name should be called.
  static const String CONVERSATION_GROUP_STORE_NAME = "conversation_group";

  // Create a instance to perform DB operations
  final _conversationGroupStore = intMapStoreFactory.store(CONVERSATION_GROUP_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addConversationGroup(ConversationGroup conversationGroup) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    ConversationGroup existingConversationGroup = await getSingleConversationGroup(conversationGroup.id);
    int key = isObjectEmpty(existingConversationGroup) ? await _conversationGroupStore.add(await _db, conversationGroup.toJson()) : editConversationGroup(conversationGroup);

    return key != null && key != 0 && key.toString().isNotEmpty;
  }

  Future<bool> editConversationGroup(ConversationGroup conversationGroup) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", conversationGroup.id));

    var noOfUpdated = await _conversationGroupStore.update(await _db, conversationGroup.toJson(), finder: finder);
    return noOfUpdated == 1;
  }

  Future<bool> deleteConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", conversationGroupId));

    var noOfDeleted = await _conversationGroupStore.delete(await _db, finder: finder);
    return noOfDeleted == 1;
  }

  Future<void> deleteAllConversationGroups() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    _conversationGroupStore.delete(await _db);
  }

  Future<ConversationGroup> getSingleConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", conversationGroupId));
    final recordSnapshot = await _conversationGroupStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? ConversationGroup.fromJson(recordSnapshot.value) : null;
  }

  Future<List<ConversationGroup>> getAllConversationGroups() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    // Auto sort by createdDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('createdDate')]);
    // Find all Conversation Groups
    final recordSnapshots = await _conversationGroupStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ConversationGroup> conversationGroupList = [];
      recordSnapshots.forEach((snapshot) {
        final conversationGroup = ConversationGroup.fromJson(snapshot.value);
        conversationGroupList.add(conversationGroup);
      });

      return conversationGroupList;
    }
    return null;
  }
}
