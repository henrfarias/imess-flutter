import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/splash.png', width: 300, height: 300),
          const Text("Bem vindo ao IMess",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      )),
    );
  }
}
