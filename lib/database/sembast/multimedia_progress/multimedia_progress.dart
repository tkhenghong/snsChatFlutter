import 'package:sembast/sembast.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

import '../SembastDB.dart';

class MultimediaProgressDBService {
  static const String MULTIMEDIA_STORE_NAME = "multimediaProgress";

  final StoreRef _multimediaProgressStore = intMapStoreFactory.store(MULTIMEDIA_STORE_NAME);

  Future<Database> get _db async => await SembastDB.instance.database;

  //CRUD
  Future<bool> addMultimediaProgress(MultimediaProgress multimediaProgress) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    int key = await getSingleMultimediaProgressKey(multimediaProgress.taskId);
    if(isObjectEmpty(key)) {
      int key = await _multimediaProgressStore.add(await _db, multimediaProgress.toJson());
      return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
    } else {
      return await editMultimediaProgress(multimediaProgress, key: key);
    }

    return !isObjectEmpty(key) && key != 0 && !isStringEmpty(key.toString());
  }

  Future<bool> editMultimediaProgress(MultimediaProgress multimediaProgress, {int key}) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }

    if(isObjectEmpty(key)) {
      key = await getSingleMultimediaProgressKey(multimediaProgress.taskId);
    }

    if(isObjectEmpty(key)) {
      return false;
    }

    Map<String, dynamic> updated = await _multimediaProgressStore.record(key).update(await _db, multimediaProgress.toJson());

    return !isObjectEmpty(updated);
  }

  Future<bool> deleteMultimediaProgress(String multimediaProgressId) async {
    if (isObjectEmpty(await _db)) {
      return false;
    }
    final finder = Finder(filter: Filter.equals("id", multimediaProgressId));

    var noOfDeleted = await _multimediaProgressStore.delete(await _db, finder: finder);

    return noOfDeleted == 1;
  }

  Future<void> deleteAllMultimediaProgress() async {
    if (isObjectEmpty(await _db)) {
      return;
    }
    _multimediaProgressStore.delete(await _db);
  }

  Future<MultimediaProgress> getSingleMultimediaProgress(String multimediaProgressTaskId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("taskId", multimediaProgressTaskId));
    final recordSnapshot = await _multimediaProgressStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? MultimediaProgress.fromJson(recordSnapshot.value) : null;
  }

  Future<int> getSingleMultimediaProgressKey(String multimediaProgressTaskId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("taskId", multimediaProgressTaskId));
    final recordSnapshot = await _multimediaProgressStore.findFirst(await _db, finder: finder);
    return !isObjectEmpty(recordSnapshot) ? recordSnapshot.key : null;
  }

  Future<List<MultimediaProgress>> getMultimediaProgressOfAConversationGroup(String conversationGroupId) async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final finder = Finder(filter: Filter.equals("conversationGroupId", conversationGroupId));
    final recordSnapshots = await _multimediaProgressStore.find(await _db, finder: finder);
    if (!isObjectEmpty(recordSnapshots)) {
      List<MultimediaProgress> multimediaProgressList = [];
      recordSnapshots.forEach((snapshot) {
        final multimediaProgress = MultimediaProgress.fromJson(snapshot.value);
        multimediaProgressList.add(multimediaProgress);
      });

      return multimediaProgressList;
    }
    return null;
  }

  Future<List<MultimediaProgress>> getAllMultimediaProgress() async {
    if (isObjectEmpty(await _db)) {
      return null;
    }
    final recordSnapshots = await _multimediaProgressStore.find(await _db);
    if (!isObjectEmpty(recordSnapshots)) {
      List<MultimediaProgress> multimediaProgressList = [];
      recordSnapshots.forEach((snapshot) {
        final multimediaProgress = MultimediaProgress.fromJson(snapshot.value);
        multimediaProgressList.add(multimediaProgress);
      });

      return multimediaProgressList;
    }
    return null;
  }
}
