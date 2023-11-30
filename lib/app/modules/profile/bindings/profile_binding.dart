import 'package:get/get.dart';
import 'package:imess/app/providers/profile_provider.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileProvider>(() => ProfileProvider(), fenix: true);
    Get.put<ProfileController>(ProfileController());
  }
}
