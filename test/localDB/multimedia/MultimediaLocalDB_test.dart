import 'package:flutter_test/flutter_test.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/objects/index.dart';

void main() {
  MultimediaAPIService multimediaAPIService = MultimediaAPIService();
  MultimediaDBService multimediaDBService = MultimediaDBService();

  Multimedia createTestObject() {
    return new Multimedia(
        id: null,
        conversationId: "waiuohdaiwjbgfkj",
        userContactId: "iefkushnkjlsngs",
        messageId: "seoifnskjgbreg",
        userId: "58r4g54rdg5r4gh",
        remoteThumbnailUrl: "sefikuhsejkfhsg",
        remoteFullFileUrl: "d689gt4re56hgtr4sh",
        localThumbnailUrl: "54dfghzd4h45th56ts4r",
        localFullFileUrl: "rtsde5fb8ts5dh896sy4jh");
  }

  test("Test Create Multimedia Locally", () async {
    Multimedia multimedia = createTestObject();

    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);
    print("newMultimedia.id:" + newMultimedia.id.toString());
    await multimediaDBService.addMultimedia(newMultimedia);

    Multimedia multimediaFromLocalDB = await multimediaDBService.getSingleMultimedia(newMultimedia.id);

    expect(newMultimedia.id, isNotEmpty);
    expect(multimediaFromLocalDB.id, equals(newMultimedia.id));
  });

  test("Test Edit Multimedia Locally", () async {
    Multimedia multimedia = createTestObject();

    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);
    await multimediaDBService.addMultimedia(newMultimedia);

    Multimedia editedMultimedia = newMultimedia;
    editedMultimedia.localThumbnailUrl = "Edited localThumbnailUrl";
    editedMultimedia.remoteThumbnailUrl = "Edited remoteThumbnailUrl";
    editedMultimedia.remoteFullFileUrl = "Edited remoteFullFileUrl";

    bool edited = await multimediaAPIService.editMultimedia(editedMultimedia);
    print("edited:" + edited.toString());
    await multimediaDBService.editMultimedia(editedMultimedia);
    Multimedia multimediaFromLocalDB = await multimediaDBService.getSingleMultimedia(newMultimedia.id);

    expect(multimediaFromLocalDB.id, equals(editedMultimedia.id));
    expect(multimediaFromLocalDB.localThumbnailUrl, equals(editedMultimedia.localThumbnailUrl));
    expect(multimediaFromLocalDB.remoteThumbnailUrl, equals(editedMultimedia.remoteThumbnailUrl));
    expect(multimediaFromLocalDB.remoteFullFileUrl, equals(editedMultimedia.remoteFullFileUrl));
    expect(edited, isTrue);
  });

  test("Test Get Multimedia Locally", () async {
    Multimedia multimedia = createTestObject();

    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);

    await multimediaDBService.addMultimedia(newMultimedia);

    Multimedia multimediaFromServer = await multimediaAPIService.getSingleMultimedia(newMultimedia.id);
    Multimedia multimediaFromLocalDB = await multimediaDBService.getSingleMultimedia(newMultimedia.id);

    expect(multimediaFromServer.id, equals(newMultimedia.id));
    expect(multimediaFromLocalDB.id, equals(multimediaFromServer.id));
  });

  test("Test Delete Multimedia Locally", () async {
    Multimedia multimedia = createTestObject();

    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);
    await multimediaDBService.addMultimedia(newMultimedia);

    bool deleted = await multimediaAPIService.deleteMultimedia(multimedia.id);

    await multimediaDBService.deleteMultimedia(multimedia.id);
    print("deleted:" + deleted.toString());

    expect(deleted, isTrue);
    expect(await multimediaDBService.getSingleMultimedia(multimedia.id), null);
  });

  test("Test Get Multimedias from a Conversation Locally", () async {
    // TODO
  });
}
