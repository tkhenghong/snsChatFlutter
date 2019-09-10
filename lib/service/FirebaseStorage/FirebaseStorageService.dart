import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  // Returns remote URL of the file
  Future<String> uploadFile(String filePath, String fileName) async {
    try {
      File file = File(filePath + fileName);
      print("file.path: " + file.path);
      final StorageReference storageRef = FirebaseStorage.instance.ref().child(fileName);

      final StorageUploadTask uploadTask = storageRef.putFile(
        file,
        // You don't have to put contentType, Firebase storage will detect it automatically.
//        StorageMetadata(
//          contentType: type + '/' + extension,
//        ),
      );

      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
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
