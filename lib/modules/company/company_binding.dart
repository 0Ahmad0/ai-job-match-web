import 'package:get/get.dart';
import 'company_controller.dart';

class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CompanyController>()) {
      Get.lazyPut<CompanyController>(() => CompanyController());
    }
  }
}
