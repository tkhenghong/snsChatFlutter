import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/objects/message/message.dart';

import '../SembastDB.dart';

class MessageDBService {
  static const String MESSAGE_STORE_NAME = "message";

  final _messageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addMessage(Message message) async {
    await _messageStore.add(await _db, message.toJson());
  }

  Future editMessage(Message message) async {
    final finder = Finder(filter: Filter.equals("id", message.id));

    await _messageStore.update(await _db, message.toJson(), finder: finder);
  }

  Future deleteMessage(String messageId) async {
    final finder = Finder(filter: Filter.equals("id", messageId));

    await _messageStore.delete(await _db, finder: finder);
  }

  Future<Message> getSingleMessage(Message message) async {
    final finder = Finder(filter: Filter.equals("id", message.id));
    final recordSnapshot = await _messageStore.findFirst(await _db, finder: finder);

    return recordSnapshot.value.isNotEmpty ? Message.fromJson(recordSnapshot.value) : null;
  }

  Future<List<Message>> getAllMessages() async {
    // Auto sort by createdDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('createdDate')]);
    // Find all Conversation Groups
    final recordSnapshots = await _messageStore.find(await _db, finder: finder);
    List<Message> messageList = recordSnapshots.map((snapshot) {
      final message = Message.fromJson(snapshot.value);
      print("conversationGroup.id: " + message.id);
      print("snapshot.key: " +
          snapshot.key.toString());
      message.id = snapshot.key.toString();
      return message;
    });

    return messageList;
  }
}
