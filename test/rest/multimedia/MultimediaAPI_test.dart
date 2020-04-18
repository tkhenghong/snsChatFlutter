import 'package:flutter_test/flutter_test.dart';

import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/objects/index.dart';

void main() {
  MultimediaAPIService multimediaAPIService = MultimediaAPIService();

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
      localFullFileUrl: "rtsde5fb8ts5dh896sy4jh",
    );
  }

  test("Test Create Multimedia", () async {
    Multimedia multimedia = createTestObject();
    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);
    print("newMultimedia.id:" + newMultimedia.id.toString());
    expect(newMultimedia.id, isNotEmpty);
  });

  test("Test Edit Multimedia", () async {
    Multimedia multimedia = createTestObject();
    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);
    Multimedia editedMultimedia = newMultimedia;
    editedMultimedia.localThumbnailUrl = "Edited localThumbnailUrl";
    editedMultimedia.remoteThumbnailUrl = "Edited remoteThumbnailUrl";
    editedMultimedia.remoteFullFileUrl = "Edited remoteFullFileUrl";
    bool edited = await multimediaAPIService.editMultimedia(editedMultimedia);
    print("edited:" + edited.toString());

    expect(edited, isTrue);
  });

  test("Test Get Multimedia", () async {
    Multimedia multimedia = createTestObject();
    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);
    Multimedia multimediaFromServer = await multimediaAPIService.getSingleMultimedia(newMultimedia.id);
    print("multimediaFromServer.id == newMultimedia.id:" + (multimediaFromServer.id == newMultimedia.id).toString());
    expect(multimediaFromServer.id == newMultimedia.id, isTrue);
  });

  test("Test Delete Multimedia", () async {
    Multimedia multimedia = createTestObject();
    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);
    print("newMultimedia.id: "  + newMultimedia.id);
    bool deleted = await multimediaAPIService.deleteMultimedia(newMultimedia.id);
    print("deleted:" + deleted.toString());
    expect(deleted, isTrue);
  });

  test("Test Get Multimedias from a Conversation", () async {
    // TODO
  });
}
