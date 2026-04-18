import 'package:get/get.dart';
import '../controllers/applications_controller.dart';

class ApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApplicationsController>()) {
      Get.lazyPut<ApplicationsController>(() => ApplicationsController());
    }
  }
}

