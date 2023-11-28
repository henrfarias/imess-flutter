import 'package:get/get.dart';
import 'package:imess/app/modules/auth/controllers/auth_controller.dart';
import 'package:imess/app/providers/auth_provider.dart';

class LoginController extends GetxController {
  AuthProvider authProvider = Get.find();

  Future<bool> handleSignIn() async {
    return authProvider.handleGoogleSignIn();
  }

  Status getAuthStatus() => authProvider.authController.status.value;
}
