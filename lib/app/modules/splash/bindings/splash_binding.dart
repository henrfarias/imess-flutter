import 'package:get/get.dart';
import 'package:imess/app/modules/auth/controllers/auth_controller.dart';
import 'package:imess/app/providers/auth_provider.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<AuthProvider>(
        () => AuthProvider(
              authController: Get.find<AuthController>(),
            ),
        fenix: true);
    Get.put<SplashController>(SplashController());
  }
}
