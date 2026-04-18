import 'package:get/get.dart';
import '../controllers/seeker_home_controller.dart';

class SeekerHomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SeekerHomeController>()) {
      Get.lazyPut<SeekerHomeController>(() => SeekerHomeController());
    }
  }
}
