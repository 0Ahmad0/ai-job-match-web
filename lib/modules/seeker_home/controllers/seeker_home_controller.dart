// lib/modules/seeker_home/controllers/seeker_home_controller.dart
import 'package:ai_job_matcher/routes/app_routes.dart';
import 'package:get/get.dart';

class SeekerHomeController extends GetxController {
  // ✅ يجب أن يكون obs ليعمل الـ Obx
  final userName = "Ahmed".obs;

  void onUploadCvTap() {
    Get.toNamed(Routes.AI_ANALYZER);
    print("Go to Upload & Analyze");
  }

  void onCreateCvTap() {
    Get.toNamed(Routes.CV_BUILDER);
    print("Go to CV Builder");

  }
}