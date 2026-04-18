import 'package:get/get.dart';
import '../controllers/post_job_controller.dart';

class PostJobBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PostJobController>()) {
      Get.lazyPut<PostJobController>(() => PostJobController());
    }
  }
}

