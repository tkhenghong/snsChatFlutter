import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

import '../SembastDB.dart';

class MultimediaDBService {
  static const String MULTIMEDIA_STORE_NAME = "multimedia";

  final _multimediaStore = intMapStoreFactory.store(MULTIMEDIA_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future addMultimedia(Multimedia multimedia) async {
    await _multimediaStore.add(await _db, multimedia.toJson());
  }

  Future editMultimedia(Multimedia multimedia) async {
    final finder = Finder(filter: Filter.equals("id", multimedia.id));

    await _multimediaStore.update(await _db, multimedia.toJson(), finder: finder);
  }

  Future deleteMultimedia(String multimediaId) async {
    final finder = Finder(filter: Filter.equals("id", multimediaId));

    await _multimediaStore.delete(await _db, finder: finder);
  }

  Future<Multimedia> getSingleMultimedia(Multimedia multimedia) async {
    final finder = Finder(filter: Filter.equals("id", multimedia.id));
    final recordSnapshot = await _multimediaStore.findFirst(await _db, finder: finder);

    return recordSnapshot.value.isNotEmpty ? Multimedia.fromJson(recordSnapshot.value) : null;
  }

  Future<List<Multimedia>> getMultimediaOfAConversationGroup(String conversationGroupId) async {
    final finder = Finder(filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshots = await _multimediaStore.find(await _db, finder: finder);

    List<Multimedia> multimediaList = recordSnapshots.map((snapshot) {
      final multimedia = Multimedia.fromJson(snapshot.value);
      print("multimedia.id: " + multimedia.id);
      print("snapshot.key: " + snapshot.key.toString());
      multimedia.id = snapshot.key.toString();
      return multimedia;
    });

    return multimediaList;
  }

  Future<List<Multimedia>> getAllMultimedia() async {
    final recordSnapshots = await _multimediaStore.find(await _db);
    List<Multimedia> multimediaList = recordSnapshots.map((snapshot) {
      final multimedia = Multimedia.fromJson(snapshot.value);
      print("multimedia.id: " + multimedia.id);
      print("snapshot.key: " + snapshot.key.toString());
      multimedia.id = snapshot.key.toString();
      return multimedia;
    });

    return multimediaList;
  }
}
