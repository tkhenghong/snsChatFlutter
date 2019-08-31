import 'dart:convert';

import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

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
    var key = existingConversationGroup == null ? await _conversationGroupStore.add(await _db, conversationGroup.toJson()) : null;

    // Return added or not added
    return !isStringEmpty(key.toString());
  }

  Future<bool> editConversationGroup(ConversationGroup conversationGroup) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", conversationGroup.id));

    var noOfUpdated = await _conversationGroupStore.update(await _db, conversationGroup.toJson(), finder: finder);
    print("ConversationDBService.dart noOfUpdated: " + noOfUpdated.toString());
    print("ConversationDBService.dart noOfUpdated == 1: " + (noOfUpdated == 1).toString());
    return noOfUpdated == 1;
  }

  Future<bool> deleteConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", conversationGroupId));

    var noOfDeleted = await _conversationGroupStore.delete(await _db, finder: finder);
    print("ConversationDBService.dart noOfDeleted: " + noOfDeleted.toString());
    print("ConversationDBService.dart noOfDeleted == 1: " + (noOfDeleted == 1).toString());
    return noOfDeleted == 1;
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
      List<ConversationGroup> conversationGroupList = recordSnapshots.map((snapshot) {
        final conversationGroup = ConversationGroup.fromJson(snapshot.value);
        print("conversationGroup.id: " + conversationGroup.id);
        print("snapshot.key: " +
            snapshot.key
                .toString()); // The instructor said snapshot.key is uniquely generated by Sembast DB. // TODO: What about the same thing generated by MongoDB?
        conversationGroup.id = snapshot.key.toString(); // The example put this, check if I don't do this what will happen?
        return conversationGroup;
      });
      // .toList(); // example put this, check if I don't put this line of code what will happen?

      return conversationGroupList;
    }
    return null;
  }
}
