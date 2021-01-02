import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class ConversationDBService {
  // Same like mongoDB, this setups what the collection name should be called.
  static const String CONVERSATION_GROUP_STORE_NAME = 'conversation_group';

  // Create a instance to perform DB operations
  final StoreRef _conversationGroupStore = intMapStoreFactory.store(CONVERSATION_GROUP_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  /// Add single conversation group.
  Future<bool> addConversationGroup(ConversationGroup conversationGroup) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    int key = await getSingleConversationGroupKey(conversationGroup.id);

    if (isObjectEmpty(key)) {
      int key = await _conversationGroupStore.add(await _db, conversationGroup.toJson());
      return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
    } else {
      return await editConversationGroup(conversationGroup, key: key);
    }
  }

  /// Add conversation group in batch, with transaction safety.
  Future<void> addConversationGroups(List<ConversationGroup> conversationGroups) async {
    Database database = await _db;
    if (isObjectEmpty(database)) {
      return false;
    }

    try {
      await database.transaction((transaction) async {
        for (int i = 0; i < conversationGroups.length; i++) {
          int existingConversationGroupKey = await getSingleConversationGroupKey(conversationGroups[i].id);
          isObjectEmpty(existingConversationGroupKey) ? await _conversationGroupStore.add(database, conversationGroups[i].toJson()) : editConversationGroup(conversationGroups[i], key: existingConversationGroupKey);
        }
      });

      return true;
    } catch (e) {
      print('SembastDB Conversation Group addConversationGroups() Error: $e');
      // Error happened in database transaction.
      return false;
    }
  }

  Future<bool> editConversationGroup(ConversationGroup conversationGroup, {int key}) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    if(isObjectEmpty(key)) {
      key = await getSingleConversationGroupKey(conversationGroup.id);
    }

    if(isObjectEmpty(key)) {
      return false;
    }

    Map<String, dynamic> updated = await _conversationGroupStore.record(key).update(await _db, conversationGroup.toJson());

    return !isObjectEmpty(updated);
  }

  Future<bool> deleteConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals('id', conversationGroupId));

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
    final finder = Finder(filter: Filter.equals('id', conversationGroupId));
    final recordSnapshot = await _conversationGroupStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? ConversationGroup.fromJson(recordSnapshot.value) : null;
  }

  Future<int> getSingleConversationGroupKey(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', conversationGroupId));
    final recordSnapshot = await _conversationGroupStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? recordSnapshot.key : null;
  }

  Future<ConversationGroup> getConversationGroupWithTypeAndMembers(ConversationGroupType conversationGroupType, List<String> groupMemberIds) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }

    final conversationGroupTypeFilter = Filter.equals('conversationGroupType', conversationGroupType.name);
    final memberIdsFilter = Filter.inList('memberIds', groupMemberIds);
    final combinedFilters = Filter.and([conversationGroupTypeFilter, memberIdsFilter]);
    final finder = Finder(filter: combinedFilters);

    final recordSnapshot = await _conversationGroupStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? ConversationGroup.fromJson(recordSnapshot.value) : null;
  }

  Future<List<ConversationGroup>> getAllConversationGroups() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    // Auto sort by createdDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('lastModifiedDate', false)]);
    // Find all conversation_group.darts
    final recordSnapshots = await _conversationGroupStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ConversationGroup> conversationGroupList = [];
      recordSnapshots.forEach((snapshot) {
        final conversationGroup = ConversationGroup.fromJson(snapshot.value);
        conversationGroupList.add(conversationGroup);
      });

      return conversationGroupList;
    }
    return [];
  }

  Future<List<ConversationGroup>> getAllConversationGroupsWithPagination(int page, int size) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    // Auto sort by lastModifiedDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('lastModifiedDate', false)], offset: page * size, limit: size);
    // Find all conversation_group.darts
    final recordSnapshots = await _conversationGroupStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ConversationGroup> conversationGroupList = [];
      recordSnapshots.forEach((snapshot) {
        final conversationGroup = ConversationGroup.fromJson(snapshot.value);
        conversationGroupList.add(conversationGroup);
      });

      return conversationGroupList;
    }
    return [];
  }
}
