import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class ChatMessageDBService {
  static const String MESSAGE_STORE_NAME = "chatMessage";

  final _chatMessageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addChatMessage(ChatMessage chatMessage) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    ChatMessage existingChatMessage = await getSingleChatMessage(chatMessage.id);

    if (isObjectEmpty(existingChatMessage)) {
      int key = await _chatMessageStore.add(await _db, chatMessage.toJson());
      return key != null && key != 0 && key.toString().isNotEmpty;
    } else {
      return await editChatMessage(chatMessage);
    }
  }

  Future<bool> editChatMessage(ChatMessage chatMessage) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", chatMessage.id));

    var noOfUpdated = await _chatMessageStore.update(await _db, chatMessage.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteChatMessage(String chatMessageId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", chatMessageId));

    var noOfDeleted = await _chatMessageStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllChatMessages() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    _chatMessageStore.delete(await _db);
  }

  Future<ChatMessage> getSingleChatMessage(String chatMessageId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", chatMessageId));
    final recordSnapshot = await _chatMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? ChatMessage.fromJson(recordSnapshot.value) : null;
  }

  Future<List<ChatMessage>> getChatMessagesOfAConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshots = await _chatMessageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ChatMessage> chatMessageList = [];
      recordSnapshots.forEach((snapshot) {
        final chatMessage = ChatMessage.fromJson(snapshot.value);
        chatMessageList.add(chatMessage);
      });

      return chatMessageList;
    }
    return null;
  }

  Future<List<ChatMessage>> getAllChatMessages() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(sortOrders: [SortOrder('createdDate')]);
    final recordSnapshots = await _chatMessageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ChatMessage> chatMessageList = [];
      recordSnapshots.forEach((snapshot) {
        final chatMessage = ChatMessage.fromJson(snapshot.value);
        chatMessageList.add(chatMessage);
      });

      return chatMessageList;
    }
    return null;
  }
}
