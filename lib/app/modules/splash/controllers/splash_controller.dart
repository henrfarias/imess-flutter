import 'package:get/get.dart';
import 'package:imess/app/providers/auth_provider.dart';
import 'package:imess/app/routes/app_pages.dart';

class SplashController extends GetxController {
  AuthProvider authProvider = Get.find();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () async {
      if(await authProvider.isLoggedIn()) {
        Get.offNamed(Routes.HOME);
      } else {
        Get.offNamed(Routes.LOGIN);
      }
    });
  }
}
