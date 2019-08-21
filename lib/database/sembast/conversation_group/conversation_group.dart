import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import '../SembastDB.dart';

class ConversationDBService {

  // Same like mongoDB, this setups what the collection name should be called.
  static const String CONVERSATION_GROUP_STORE_NAME = "conversation_group";

  // Create a instance to perform DB operations
  final _conversationGroupStore = intMapStoreFactory.store(CONVERSATION_GROUP_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addConversationGroup(ConversationGroup conversationGroup) async {
    await _conversationGroupStore.add(await _db, conversationGroup.toJson());
  }

  Future editConversationGroup(ConversationGroup conversationGroup) async {
    final finder = Finder(filter: Filter.byKey(conversationGroup.id));

    await _conversationGroupStore.update(await _db, conversationGroup.toJson(), finder: finder);
  }

  Future deleteConversationGroup(ConversationGroup conversationGroup) async {
    final finder = Finder(filter: Filter.byKey(conversationGroup.id));

    await _conversationGroupStore.delete(await _db, finder: finder);
  }

  getSingleConversationGroup() {}

  getAllConversationGroups() {}
}
