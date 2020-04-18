import 'package:sembast/sembast.dart';

import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/index.dart';
import '../SembastDB.dart';

class ChatMessageDBService {
  static const String MESSAGE_STORE_NAME = "message";

  final _messageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addChatMessage(ChatMessage message) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    ChatMessage existingChatMessage = await getSingleChatMessage(message.id);
    var key = existingChatMessage == null
        ? await _messageStore.add(await _db, message.toJson())
        : null;

    return !isStringEmpty(key.toString());
  }

  Future<bool> editChatMessage(ChatMessage message) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", message.id));

    var noOfUpdated =
        await _messageStore.update(await _db, message.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteChatMessage(String messageId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", messageId));

    var noOfDeleted = await _messageStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<ChatMessage> getSingleChatMessage(String messageId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", messageId));
    final recordSnapshot =
        await _messageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot)
        ? ChatMessage.fromJson(recordSnapshot.value)
        : null;
  }

  Future<List<ChatMessage>> getChatMessagesOfAConversationGroup(
      String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(
        filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshots = await _messageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ChatMessage> messageList = [];
      recordSnapshots.forEach((snapshot) {
        final message = ChatMessage.fromJson(snapshot.value);
        messageList.add(message);
      });

      return messageList;
    }
    return null;
  }

  Future<List<ChatMessage>> getAllChatMessages() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(sortOrders: [SortOrder('createdDate')]);
    final recordSnapshots = await _messageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ChatMessage> messageList = [];
      recordSnapshots.forEach((snapshot) {
        final message = ChatMessage.fromJson(snapshot.value);
        messageList.add(message);
      });

      return messageList;
    }
    return null;
  }
}
