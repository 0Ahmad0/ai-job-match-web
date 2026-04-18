import 'package:get/get.dart';
import 'job_seeker_controller.dart';

class JobSeekerBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<JobSeekerController>()) {
      Get.lazyPut<JobSeekerController>(() => JobSeekerController());
    }
  }
}
