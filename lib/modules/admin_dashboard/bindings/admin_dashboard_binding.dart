import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AdminDashboardController>()) {
      Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
    }
  }
}

