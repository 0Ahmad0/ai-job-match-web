import 'package:ai_job_matcher/modules/profile/controllers/notifications_controller.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    );
  }
}
