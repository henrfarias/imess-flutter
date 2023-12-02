import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ConversationsProvider extends GetConnect implements GetxService {
  final FirebaseFirestore firebaseFirestore;

  ConversationsProvider({required this.firebaseFirestore});

  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  Stream<QuerySnapshot> getFirestoreData(
      String collectionPath, int limit) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
  }
}
