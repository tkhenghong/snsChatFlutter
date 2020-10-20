import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:snschat_flutter/general/index.dart';

@deprecated
class FirebaseStorageService {
  // Returns remote URL of the file
  // String type value: User, UserContact, GroupPhoto, Message. Defines the Category of the file when it's uploaded to the Storage
  // String id: userId, UserContactId, conversationGroupId, messageId
  // Directory in Firebase Storage format:
  Future<String> uploadFile(String filePath, ConversationGroupType type, String id) async {
    try {
      File file = File(filePath);

      int lastSlash = file.path.lastIndexOf("/");
      int lastDot = file.path.lastIndexOf(".");
      String fileName = file.path.substring(lastSlash + 1, lastDot);
      String fileFormat = file.path.substring(lastDot + 1, file.path.length);

      String filePathInFirebaseStorage = '$type/$id/$fileName.$fileFormat';

      // Upload
      StorageReference storageRef = FirebaseStorage.instance.ref().child(filePathInFirebaseStorage);
      String uploadPath = await storageRef.getPath();
      StorageUploadTask uploadTask = storageRef.putFile(file);

      // Get Remote URL
      StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
      final String url = (await downloadUrl.ref.getDownloadURL());

      return url;
    } catch (e) {
      print("Upload failed. Reason: " + e.toString());
      throw new Error();
    }
  }
}
