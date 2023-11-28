import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status {
  pending,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Rx<Status> status = Status.pending.obs;

  changeStatus(Status status) => this.status.value = status;
}