import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imess/app/modules/auth/controllers/auth_controller.dart';
import 'package:imess/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.find();
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            children: [
              const SizedBox(height: 50),
              const Text(
                'Bem vindo ao IMess',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                'Faça o login para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 50),
              Center(
                child: Image.asset('assets/images/login_screen.png'),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  bool isSuccess = await loginController.handleSignIn();
                  if (isSuccess) {
                    Get.offNamed(Routes.HOME);
                  }
                },
                child: Image.asset('assets/images/google_login.jpg',
                    alignment: Alignment.center),
              )
            ],
          ),
          Center(child: Obx(() {
            return loginController.getAuthStatus() == Status.authenticating
                ? const CircularProgressIndicator(
                    color: Colors.grey,
                  )
                : const SizedBox.shrink();
          }))
        ],
      ),
    );
  }
}
