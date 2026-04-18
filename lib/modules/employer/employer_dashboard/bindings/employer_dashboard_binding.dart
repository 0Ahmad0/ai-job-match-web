import 'package:get/get.dart';
import '../controllers/employer_dashboard_controller.dart';

class EmployerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EmployerDashboardController>()) {
      Get.lazyPut<EmployerDashboardController>(() => EmployerDashboardController());
    }
  }
}

