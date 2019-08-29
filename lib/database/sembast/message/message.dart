import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/message/message.dart';

import '../SembastDB.dart';

class MessageDBService {
  static const String MESSAGE_STORE_NAME = "message";

  final _messageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addMessage(Message message) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    var key = await _messageStore.add(await _db, message.toJson());

    return !isStringEmpty(key.toString());
  }

  Future<bool> editMessage(Message message) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", message.id));

    var noOfUpdated = await _messageStore.update(await _db, message.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteMessage(String messageId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", messageId));

    var noOfDeleted = await _messageStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<Message> getSingleMessage(String messageId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", messageId));
    final recordSnapshot = await _messageStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? Message.fromJson(recordSnapshot.value) : null;
  }

  Future<List<Message>> getMessagesOfAConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshots = await _messageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<Message> messageList = recordSnapshots.map((snapshot) {
        final message = Message.fromJson(snapshot.value);
        print("message.id: " + message.id);
        print("snapshot.key: " + snapshot.key.toString());
        message.id = snapshot.key.toString();
        return message;
      });

      return messageList;
    }
    return null;
  }

  Future<List<Message>> getAllMessages() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(sortOrders: [SortOrder('createdDate')]);
    final recordSnapshots = await _messageStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<Message> messageList = recordSnapshots.map((snapshot) {
        final message = Message.fromJson(snapshot.value);
        print("message.id: " + message.id);
        print("snapshot.key: " + snapshot.key.toString());
        message.id = snapshot.key.toString();
        return message;
      });

      return messageList;
    }
    return null;
  }
}
