import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:izahs/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  Future<String?> uploadProfileImageMobile(Uint8List path, String fileName) {
    // TODO: implement uploadProfileImageMobile
    throw UnimplementedError();
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    // TODO: implement uploadProfileImageWeb
    throw UnimplementedError();
  }
}

/*

HELPER METHODS - to upload files to storage
 */

// mobile platforms (file)
Future<String?> _uploadFile(String path, String fileName, String folder) async {
  try {
    //  get file
    final file = File(path);

    // find place to store
    // final storageRef = storage
  } catch (e) {}
}
