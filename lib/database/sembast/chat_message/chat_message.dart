import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class ChatMessageDBService {
  static const String MESSAGE_STORE_NAME = 'chatMessage';

  final StoreRef _chatMessageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  /// Add single chat message.
  Future<bool> addChatMessage(ChatMessage chatMessage) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    int existingChatMessageKey = await getSingleChatMessageKey(chatMessage.id);

    if (isObjectEmpty(existingChatMessageKey)) {
      Map<String, dynamic> chatMessageMap = chatMessage.toJson();

      int key = await _chatMessageStore.add(await _db, chatMessageMap);
      return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
    } else {
      return await editChatMessage(chatMessage, key: existingChatMessageKey);
    }
  }

  Future<bool> addChatMessages(List<ChatMessage> chatMessages) async {
    Database database = await _db;
    if (isObjectEmpty(database)) {
      return false;
    }

    try {
      await database.transaction((transaction) async {
        for (int i = 0; i < chatMessages.length; i++) {
          int existingChatMessageKey = await getSingleChatMessageKey(chatMessages[i].id);
          isObjectEmpty(existingChatMessageKey) ? await _chatMessageStore.add(database, chatMessages[i].toJson()) : editChatMessage(chatMessages[i], key: existingChatMessageKey);
        }
      });

      return true;
    } catch (e) {
      print('SembastDB Chat Message addChatMessages() Error: $e');
      // Error happened in database transaction.
      return false;
    }
  }

  Future<bool> editChatMessage(ChatMessage chatMessage, {int key}) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    if (isObjectEmpty(key)) {
      key = await getSingleChatMessageKey(chatMessage.id);
    }

    if (isObjectEmpty(key)) {
      return false;
    }

    Map<String, dynamic> updated = await _chatMessageStore.record(key).update(await _db, chatMessage.toJson());

    return !isObjectEmpty(updated);
  }

  Future<bool> deleteChatMessage(String chatMessageId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals('id', chatMessageId));

    var noOfDeleted = await _chatMessageStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllChatMessages() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    await _chatMessageStore.delete(await _db);
  }

  Future<ChatMessage> getSingleChatMessage(String chatMessageId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', chatMessageId));
    final recordSnapshot = await _chatMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? ChatMessage.fromJson(recordSnapshot.value) : null;
  }

  Future<int> getSingleChatMessageKey(String chatMessageId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', chatMessageId));
    final recordSnapshot = await _chatMessageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? recordSnapshot.key : null;
  }

  Future<List<ChatMessage>> getChatMessagesOfAConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('conversationId', conversationGroupId));
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

  Future<List<ChatMessage>> getAllChatMessagesWithPagination(String conversationGroupId, int page, int size) async {
    if (isObjectEmpty(await _db)) {
      return [];
    }
    // Auto sort by lastModifiedDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('lastModifiedDate', false)], filter: Filter.equals('conversationId', conversationGroupId), offset: page * size, limit: size);
    // Find all Conversation Groups
    final recordSnapshots = await _chatMessageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<ChatMessage> chatMessageList = [];
      recordSnapshots.forEach((snapshot) {
        final conversationGroup = ChatMessage.fromJson(snapshot.value);
        chatMessageList.add(conversationGroup);
      });

      return chatMessageList;
    }
    return [];
  }
}
