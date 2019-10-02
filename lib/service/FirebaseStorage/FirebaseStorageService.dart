import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  // Returns remote URL of the file
  // String type value: User, UserContact, GroupPhoto, Message. Defines the Category of the file when it's uploaded to the Storage
  // String id: userId, UserContactId, conversationGroupId, messageId
  // Directory in Firebase Storage format:
  Future<String> uploadFile(String filePath, String type, String id) async {
    try {
      File file = File(filePath);
      print("file.path: " + file.path);

      int lastSlash = file.path.lastIndexOf("/");
      int lastDot = file.path.lastIndexOf(".");
      String fileName = file.path.substring(lastSlash + 1, lastDot);
      String fileFormat = file.path.substring(lastDot + 1, file.path.length);

      print("fileName: " + fileName);

      String filePathInFirebaseStorage = '$type/$id/$fileName.$fileFormat';
      print("filePathInFirebaseStorage: " + filePathInFirebaseStorage);

      // Upload
      StorageReference storageRef = FirebaseStorage.instance.ref().child(filePathInFirebaseStorage);
      String uploadPath = await storageRef.getPath();
      print("Uploading to " + uploadPath);
      StorageUploadTask uploadTask = storageRef.putFile(file);

      // If meet these User Profile photo, Group Conversation Photo, or
      // Create Thumbnail for them
      if (type == "GroupPhoto" || type == "User" || type == "UserContact") {
        print("if (type == \"GroupPhoto\" || type == \"User\" || type == \"UserContact\")");
        String filePathInFirebaseStorage = '$type/$id/thumbnail-$fileName.$fileFormat';
        print("filePathInFirebaseStorage (thumbnail): " + filePathInFirebaseStorage);
        StorageReference thumbnailRef = FirebaseStorage.instance.ref().child(filePathInFirebaseStorage);
        String uploadThumbnailPath = await thumbnailRef.getPath();
        print("Uploading to " + uploadThumbnailPath);
        StorageUploadTask uploadThumbnailTask = thumbnailRef.putFile(file);
        StorageTaskSnapshot downloadThumbnailUrl = await uploadThumbnailTask.onComplete;
        String thumbnailURL = await downloadThumbnailUrl.ref.getDownloadURL();
        print("thumbnailURL: " + thumbnailURL);
      }

      // Get Remote URL
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
