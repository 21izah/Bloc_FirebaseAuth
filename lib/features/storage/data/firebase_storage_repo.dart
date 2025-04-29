import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:izahs/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  /*

HELPER METHODS - to upload files to storage
 */

// mobile platforms (file)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      //  get file
      final file = File(path);

      // find palce to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putFile(file);

      // get iamge download url
      final downlaodUrl = await uploadTask.ref.getDownloadURL();
      return downlaodUrl;
    } catch (e) {
      return null;
    }
  }

  // web platform (bytes)
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      // find a palce to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // upload
      final uplaodTask = await storageRef.putData(fileBytes);

      // get image downlaod url
      final downlaodUrl = await uplaodTask.ref.getDownloadURL();
      return downlaodUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // for post

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  // for post
}
