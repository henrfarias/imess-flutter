import 'package:get/get.dart';
import 'package:imess/app/modules/auth/controllers/auth_controller.dart';
import 'package:imess/app/providers/auth_provider.dart';
import 'package:imess/app/providers/chat_provider.dart';

import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatProvider(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<AuthProvider>(
        () => AuthProvider(
              authController: Get.find<AuthController>(),
            ),
        fenix: true);
    Get.put<ChatController>(ChatController());
  }
}
