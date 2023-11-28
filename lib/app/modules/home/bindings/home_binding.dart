import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imess/app/modules/auth/controllers/auth_controller.dart';
import 'package:imess/app/providers/auth_provider.dart';
import 'package:imess/app/providers/conversations_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<AuthProvider>(
        () => AuthProvider(
              authController: Get.find<AuthController>(),
            ),
        fenix: true);
    Get.lazyPut<ConversationsProvider>(() =>
        ConversationsProvider(firebaseFirestore: FirebaseFirestore.instance));
    Get.put<HomeController>(HomeController());
  }
}
