import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class MultimediaDBService {
  static const String MULTIMEDIA_STORE_NAME = 'multimedia';

  final StoreRef _multimediaStore = intMapStoreFactory.store(MULTIMEDIA_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  /// Add single multimedia.
  Future<bool> addMultimedia(Multimedia multimedia) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    int key = await getSingleMultimediaKey(multimedia.id);

    if (isObjectEmpty(key)) {
      int key = await _multimediaStore.add(await _db, multimedia.toJson());
      return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
    } else {
      return await editMultimedia(multimedia, key: key);
    }
  }

  /// Add multimedia in batch, with transaction safety.
  Future<void> addMultimediaList(List<Multimedia> multimediaList) async {
    Database database = await _db;
    if (isObjectEmpty(database)) {
      return false;
    }

    try {
      await database.transaction((transaction) async {
        for (int i = 0; i < multimediaList.length; i++) {
          int existingMultimediaKey = await getSingleMultimediaKey(multimediaList[i].id);
          isObjectEmpty(existingMultimediaKey) ? await _multimediaStore.add(database, multimediaList[i].toJson()) : editMultimedia(multimediaList[i], key: existingMultimediaKey);
        }
      });

      return true;
    } catch (e) {
      print('SembastDB Multimedia addMultimediaList Error: $e');
      return false;
    }
  }

  Future<bool> editMultimedia(Multimedia multimedia, {int key}) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    if (isObjectEmpty(key)) {
      key = await getSingleMultimediaKey(multimedia.id);
    }

    if (isObjectEmpty(key)) {
      return false;
    }

    Map<String, dynamic> updated = await _multimediaStore.record(key).update(await _db, multimedia.toJson());

    return !isObjectEmpty(updated);
  }

  Future<bool> deleteMultimedia(String multimediaId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals('id', multimediaId));

    var noOfDeleted = await _multimediaStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllMultimedia() async {
    if (isObjectEmpty(await _db)) {
      return;
    }

    await _multimediaStore.delete(await _db);
  }

  Future<Multimedia> getSingleMultimedia(String multimediaId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', multimediaId));
    final recordSnapshot = await _multimediaStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? Multimedia.fromJson(recordSnapshot.value) : null;
  }

  Future<int> getSingleMultimediaKey(String multimediaId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals('id', multimediaId));
    final recordSnapshot = await _multimediaStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? recordSnapshot.key : null;
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
    return [];
  }

  Future<List<Multimedia>> getMultimediaList(List<String> multimediaList) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    // Auto sort by lastModifiedDate, but when showing in chat page, sort these conversations using last unread message's date
    final finder = Finder(sortOrders: [SortOrder('lastModifiedDate', false)], filter: Filter.inList('id', multimediaList));
    final recordSnapshots = await _multimediaStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<Multimedia> multimediaList = [];
      recordSnapshots.forEach((snapshot) {
        final multimedia = Multimedia.fromJson(snapshot.value);
        multimediaList.add(multimedia);
      });

      return multimediaList;
    }
    return [];
  }
}
