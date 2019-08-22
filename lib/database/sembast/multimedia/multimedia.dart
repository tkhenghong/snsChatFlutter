import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

import '../SembastDB.dart';

class MultimediaDBService {
  static const String MESSAGE_STORE_NAME = "message";

  final _messageStore = intMapStoreFactory.store(MESSAGE_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addMultimedia(Multimedia multimedia) async {}

  Future editMultimedia(Multimedia multimedia) async {}

  Future deleteMultimedia(Multimedia multimedia) async {}

  Future<Multimedia> getSingleMultimedia() async {}

  Future<List<Multimedia>> getMultimediaOfAConversationGroup(String conversationGroupId) async {}

  Future<List<Multimedia>> getAllMultimedia() async {}
}
