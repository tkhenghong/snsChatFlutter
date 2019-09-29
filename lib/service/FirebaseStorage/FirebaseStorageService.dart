import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';


class FirebaseStorageService {
  // Returns remote URL of the file
  // String type value: User, UserContact, GroupPhoto, Message
  // String id: userId, UserContactId, conversationGroupId, messageId
  // Directory in Firebase Storage format:
  Future<String> uploadFile(String filePath, String type, String id) async {
    try {
      File file = File(filePath);
      print("file.path: " + file.path);

      int lastSlash = file.path.lastIndexOf("/");
      String fileName = file.path.substring(lastSlash+1, file.path.length);

      print("fileName: " + fileName);
      String fileFormat = "";
      switch(type) {
        case "UserContact":
          fileFormat = "png";
          break;
      }

      String filePathInFirebaseStorage = '$type/$id/$fileName.$fileFormat';
      print("filePathInFirebaseStorage: " + filePathInFirebaseStorage);

      StorageReference storageRef = FirebaseStorage.instance.ref().child(filePathInFirebaseStorage);
      String uploadPath = await storageRef.getPath();
      print("Uploading to " + uploadPath);
      StorageUploadTask uploadTask = storageRef.putFile(file);

      StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
      final String url = (await downloadUrl.ref.getDownloadURL());
      print('URL Is $url');

      return url;
    } catch (e) {
      print("Upload failed");
      return null;
    }
  }

  // Returns full file URL of the file at temp location (for copy to another place later)
  Future<String> downloadFile(String remoteUrl, String fileName) async {
    String uri = Uri.decodeFull(remoteUrl);
    final RegExp regex = RegExp('([^?/]*\.(jpg))');
    final String fileName = regex.stringMatch(uri);
  }
}
