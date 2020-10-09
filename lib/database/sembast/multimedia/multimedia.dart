import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class MultimediaDBService {
  static const String MULTIMEDIA_STORE_NAME = "multimedia";

  final _multimediaStore = intMapStoreFactory.store(MULTIMEDIA_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addMultimedia(Multimedia multimedia) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    Multimedia existingMultimedia = await getSingleMultimedia(multimedia.id);
    var key = isObjectEmpty(existingMultimedia) ? await _multimediaStore.add(await _db, multimedia.toJson()) : editMultimedia(multimedia);

    return key.toString().isNotEmpty;
  }

  Future<bool> editMultimedia(Multimedia multimedia) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", multimedia.id));

    var noOfUpdated = await _multimediaStore.update(await _db, multimedia.toJson(), finder: finder);

    return noOfUpdated == 1;
  }

  Future<bool> deleteMultimedia(String multimediaId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", multimediaId));

    var noOfDeleted = await _multimediaStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllMultimedia() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    _multimediaStore.delete(await _db);
  }

  Future<Multimedia> getSingleMultimedia(String multimediaId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("id", multimediaId));
    final recordSnapshot = await _multimediaStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? Multimedia.fromJson(recordSnapshot.value) : null;
  }

  Future<List<Multimedia>> getMultimediaOfAConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshots = await _multimediaStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<Multimedia> multimediaList = [];
      recordSnapshots.forEach((snapshot) {
        final multimedia = Multimedia.fromJson(snapshot.value);
        multimediaList.add(multimedia);
      });

      return multimediaList;
    }
    return null;
  }

  Future<List<Multimedia>> getAllMultimedia() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final recordSnapshots = await _multimediaStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<Multimedia> multimediaList = [];
      recordSnapshots.forEach((snapshot) {
        final multimedia = Multimedia.fromJson(snapshot.value);
        multimediaList.add(multimedia);
      });

      return multimediaList;
    }
    return null;
  }
}
