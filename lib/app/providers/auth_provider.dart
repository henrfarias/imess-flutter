import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:imess/app/modules/global/constants/firestore_constants.dart';
import 'package:imess/app/data/classes/talk_contact.dart';
import 'package:imess/app/modules/auth/controllers/auth_controller.dart';

class AuthProvider extends GetConnect implements GetxService {
  final AuthController authController;
  AuthProvider({required this.authController});
  final storage = GetStorage();

  String? getFirebaseUserId() {
    return storage.read(FirestoreConstants.id);
  }

  Future<bool> handleGoogleSignIn() async {
    authController.changeStatus(Status.authenticating);

    GoogleSignInAccount? googleUser =
        await authController.googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      User? firebaseUser =
          (await authController.firebaseAuth.signInWithCredential(credential))
              .user;
      if (firebaseUser != null) {
        final QuerySnapshot result = await authController.firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          authController.firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            FirestoreConstants.id: firebaseUser.uid,
            FirestoreConstants.displayName: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          User? currentUser = firebaseUser;
          await storage.write(FirestoreConstants.id, currentUser.uid);
          await storage.write(
              FirestoreConstants.displayName, currentUser.displayName ?? "");
          await storage.write(
              FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await storage.write(
              FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
        } else {
          DocumentSnapshot documentSnapshot = document[0];
          TalkContact talkContact = TalkContact.fromDocument(documentSnapshot);
          await storage.write(FirestoreConstants.id, talkContact.id);
          await storage.write(
              FirestoreConstants.displayName, talkContact.displayName);
          await storage.write(
              FirestoreConstants.photoUrl, talkContact.photoUrl);
          await storage.write(
              FirestoreConstants.phoneNumber, talkContact.phoneNumber);
          await storage.write(FirestoreConstants.aboutMe, talkContact.aboutMe);
        }
        authController.changeStatus(Status.authenticated);
        Get.showSnackbar(const GetSnackBar(
          title: 'Login realizado!',
          message: 'Usuário autenticado com sucesso.',
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle_outline, color: Colors.green),
        ));
        return true;
      } else {
        authController.changeStatus(Status.authenticateError);
        Get.showSnackbar(const GetSnackBar(
          title: 'Login falhou =(',
          message: 'Algo de errado aconteceu durante a autenticação.',
          duration: Duration(seconds: 3),
          icon: Icon(Icons.cancel_outlined, color: Colors.red),
        ));
        return false;
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: 'Login cancelado',
        message: 'A operação de autenticação foi cancelada.',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.cancel_outlined, color: Colors.red),
      ));
      authController.changeStatus(Status.authenticateCanceled);
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await authController.googleSignIn.isSignedIn();
    return isLoggedIn &&
        GetStorage().read(FirestoreConstants.id)?.isNotEmpty == true;
  }

  Future<void> googleSignOut() async {
    authController.changeStatus(Status.pending);
    await authController.firebaseAuth.signOut();
    await authController.googleSignIn.disconnect();
    await authController.googleSignIn.signOut();
  }
}
