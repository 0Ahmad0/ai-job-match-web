import 'package:get/get.dart';
import '../controllers/seeker_home_controller.dart';

class SeekerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeekerHomeController>(
      () => SeekerHomeController(),
    );
  }
}
