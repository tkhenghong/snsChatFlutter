import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/objects/message/message.dart';

import '../SembastDB.dart';

class MessageDBService {
  static const String MESSAGE_STORE_NAME = "message";

  final _messageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addMessage(Message message) async {}

  Future editMessage() async {}

  Future deleteMessage() async {}

  Future<Message> getSingleMessage() async {}

  Future<List<Message>> getAllMessages() async {}
}
