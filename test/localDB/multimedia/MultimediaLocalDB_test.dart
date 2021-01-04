import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:uuid/uuid.dart';

void main() {
  MultimediaDBService multimediaDBService = new MultimediaDBService();

  var uuid = Uuid();

  Multimedia createTestObject() {
    Multimedia multimedia = Multimedia(
      id: uuid.v4(),
      multimediaType: MultimediaType.Video,
    );

    // UploadedFile object.
    multimedia.fileDirectory = uuid.v4();
    multimedia.fileSize = new Random().nextInt(100000);
    multimedia.fileExtension = uuid.v4();
    multimedia.contentType = uuid.v4();
    multimedia.fileName = uuid.v4();

    multimedia.createdBy = uuid.v4();
    multimedia.createdDate = DateTime.now();
    multimedia.lastModifiedBy = uuid.v4();
    multimedia.lastModifiedDate = DateTime.now();
    multimedia.version = 1;
    return multimedia;
  }

  wipeAllMultimedia() async {
    await multimediaDBService.deleteAllMultimedia();
  }

  test('Create Multimedia', () async {
    await wipeAllMultimedia();
    Multimedia multimedia = createTestObject();

    // Add
    bool added = await multimediaDBService.addMultimedia(multimedia);

    // Get
    Multimedia multimediaFromLocalDB = await multimediaDBService.getSingleMultimedia(multimedia.id);

    // Validations
    expect(added, isTrue);
    expect(multimediaFromLocalDB, isNotNull);
    expect(multimediaFromLocalDB.id, isNotNull);
    expect(multimediaFromLocalDB.id, equals(multimedia.id)); // Only comparing IDs due to no equatable package
  });

  // NOTE: Asynchronous saving the same thing into DB
  // Answer: You will not even getting the database even after delayed for 5 seconds after you have saved the same conversation group twice into DB.
  test('Create Multimedia Asynchronously', () async {
    await wipeAllMultimedia();
    Multimedia multimedia = createTestObject();

    // Add
    multimediaDBService.addMultimedia(multimedia);

    // Edit
    multimedia.fileName = uuid.v4();

    multimediaDBService.addMultimedia(multimedia);

    // Get
    Multimedia multimediaFromLocalDB = await multimediaDBService.getSingleMultimedia(multimedia.id);

    // Validations
    expect(multimediaFromLocalDB, isNull);
  });

  test('Create and Edit Multimedia', () async {
    await wipeAllMultimedia();
    Multimedia multimedia = createTestObject();

    // Add
    bool added;
    try {
      added = await multimediaDBService.addMultimedia(multimedia);
    } catch (e) {
      print('Create and Edit Multimedia failed. e: $e');
      added = false;
    }

    // Get
    Multimedia multimediaFromLocalDB = await multimediaDBService.getSingleMultimedia(multimedia.id);

    // Edit
    multimedia.fileName = uuid.v4();
    multimedia.multimediaType = MultimediaType.Document;

    bool edited = await multimediaDBService.editMultimedia(multimedia);
    Multimedia editedMultimedia = await multimediaDBService.getSingleMultimedia(multimedia.id);

    // Validations
    expect(added, isTrue);
    expect(edited, isTrue);
    expect(multimediaFromLocalDB, isNotNull);
    expect(editedMultimedia.id, isNotNull);
    expect(editedMultimedia.id, equals(multimediaFromLocalDB.id));
    expect(editedMultimedia.fileName, isNotNull);
    expect(editedMultimedia.fileName, equals(multimedia.fileName));
    expect(editedMultimedia.multimediaType, isNotNull);
    expect(editedMultimedia.multimediaType, equals(multimedia.multimediaType));
  });

  test('Test Save Multimedia Multiple Times', () async {
    await wipeAllMultimedia();
    Multimedia multimedia = createTestObject();

    // Set up
    int noOfRecords = 50;

    bool added = true;

    // Add
    for (int i = 0; i < noOfRecords; i++) {
      try {
        bool added2 = await multimediaDBService.addMultimedia(multimedia);
        // If one save is now saved successfully, the added variable will be false.
        if (!added2) {
          added = false;
        }
      } catch (e) {
        print('Save Multimedia multiple times failed. e: $e');
        added = false;
      }
    }

    List<Multimedia> multimediaList = await multimediaDBService.getAllMultimedia();

    expect(added, isTrue);
    expect(multimediaList.length, equals(1));
  });

  test('Test Delete Single Multimedia', () async {
    await wipeAllMultimedia();
    Multimedia multimedia = createTestObject();

    // Add
    bool added = await multimediaDBService.addMultimedia(multimedia);

    // Delete
    bool deleted = await multimediaDBService.deleteMultimedia(multimedia.id);

    Multimedia multimediaFromLocalDB = await multimediaDBService.getSingleMultimedia(multimedia.id);

    expect(added, isTrue);
    expect(deleted, isTrue);
    expect(multimediaFromLocalDB, null);
  });

  test('Test Wipe All MultimediaList', () async {
    await wipeAllMultimedia();

    // Get
    List<Multimedia> multimediaList = await multimediaDBService.getAllMultimedia();

    expect(multimediaList, equals([]));
    expect(multimediaList.length, equals(0));
  });

  test('Test Get Multimedia List with Multimedia IDs', () async {
    await wipeAllMultimedia();

    // Set up
    List<Multimedia> allMultimediaList = [];

    int noOfRecords = 50;

    bool allSavedSuccess = true;

    // Add
    for (int i = 0; i < noOfRecords; i++) {
      Multimedia multimedia = createTestObject();

      allMultimediaList.add(multimedia);

      bool added = await multimediaDBService.addMultimedia(multimedia);

      if (!added) {
        allSavedSuccess = false;
      }
    }

    // Sort by lastModifiedDate.
    allMultimediaList.sort((Multimedia multimediaA, Multimedia multimediaB) {
      return multimediaB.lastModifiedDate.millisecondsSinceEpoch - multimediaA.lastModifiedDate.millisecondsSinceEpoch;
    });

    List<String> multimediaIDs = allMultimediaList.map((e) => e.id).toList();

    expect(allSavedSuccess, isTrue);

    // Get
    List<Multimedia> multimediaListFromLocalDB = await multimediaDBService.getMultimediaList(multimediaIDs);

    expect(multimediaListFromLocalDB, isNotNull);
    expect(multimediaListFromLocalDB, isNotEmpty);
    expect(multimediaListFromLocalDB.length, equals(allMultimediaList.length));

    bool elementDoesNotExist = false;

    allMultimediaList.forEach((multimedia) {
      Multimedia element = multimediaListFromLocalDB.firstWhere((multimediaFromLocalDB) => multimediaFromLocalDB.id == multimedia.id, orElse: () => null);
      if (isObjectEmpty(element)) {
        elementDoesNotExist = true;
      }
    });

    expect(elementDoesNotExist, isFalse);

    List<String> multimediaIDsFromLocalDB = multimediaListFromLocalDB.map((e) => e.id).toList();

    expect(multimediaIDsFromLocalDB.length, equals(multimediaIDs.length));
    expect(listEquals(multimediaIDsFromLocalDB, multimediaIDs), isTrue);
  });
}
