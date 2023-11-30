import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileProvider extends GetConnect implements GetxService {
  final storage = GetStorage();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String? getData(String key) {
    return storage.read(key);
  }

  Future<void> setData(String key, String value) async {
    return await storage.write(key, value);
  }

  UploadTask uploadImageFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(String collectionPath, String path,
      Map<String, dynamic> dataUpdateNeeded) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataUpdateNeeded);
  }
}
