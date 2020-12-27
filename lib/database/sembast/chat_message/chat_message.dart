import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class ChatMessageDBService {
  static const String MESSAGE_STORE_NAME = "chatMessage";

  final StoreRef _chatMessageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  /// Add single chat message.
  Future<bool> addChatMessage(ChatMessage chatMessage) async {
    print('SembastDB chat_message.dart addChatMessage()');
    print('SembastDB chat_message.dart chatMessage.id: ${chatMessage.id}');
    print('SembastDB chat_message.dart chatMessage.messageContent: ${chatMessage.messageContent}');

    // DatabaseFactory dbFactory = databaseFactoryIo;
    // Database db = await dbFactory.openDatabase('/storage/emulated/0/Android/data/flutter.snschat.com.snschatflutter/files/pocketChat.db');
    // StoreRef _chatMessageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

    Database db = await _db;
    if (isObjectEmpty(db)) {
      print('SembastDB chat_message.dart if (isObjectEmpty(await _db))');
      return false;
    } else {
      print('SembastDB chat_message.dart if (!isObjectEmpty(await _db))');
    }

    print('SembastDB chat_message.dart CHECKPOINT 4');
    ChatMessage existingChatMessage = await getSingleChatMessage(chatMessage.id);
    print('SembastDB chat_message.dart CHECKPOINT 5');

    if (isObjectEmpty(existingChatMessage)) {
      print('SembastDB chat_message.dart if (isObjectEmpty(existingChatMessage))');
      Map<String, dynamic> chatMessageMap = chatMessage.toJson();
      print('SembastDB chat_message.dart CHECKPOINT 6 chatMessageMap: $chatMessageMap');

      int key = await _chatMessageStore.add(db, chatMessageMap);
      print('SembastDB chat_message.dart CHECKPOINT 7, key: $key');
      return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
    } else {
      print('SembastDB chat_message.dart if (!isObjectEmpty(existingChatMessage))');
      return await editChatMessage(chatMessage);
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
          ChatMessage existingChatMessage = await getSingleChatMessage(chatMessages[i].id);
          isObjectEmpty(existingChatMessage) ? await _chatMessageStore.add(database, chatMessages[i].toJson()) : editChatMessage(chatMessages[i]);
        }
      });
      print('SembastDB Chat Message addConversationGroup() END');
      return true;
    } catch (e) {
      print('SembastDB Chat Message addChatMessages() Error: $e');
      // Error happened in database transaction.
      return false;
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
    final finder = Finder(filter: Filter.equals("conversationId", conversationGroupId));
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
