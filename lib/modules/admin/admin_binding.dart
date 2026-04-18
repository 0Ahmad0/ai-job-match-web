import 'package:get/get.dart';
import 'admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AdminController>()) {
      Get.lazyPut<AdminController>(() => AdminController());
    }
  }
}
