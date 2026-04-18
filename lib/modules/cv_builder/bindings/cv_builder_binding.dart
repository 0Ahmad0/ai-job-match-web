import 'package:get/get.dart';
import '../../../data/services/gemini_service.dart';
import '../controllers/cv_builder_controller.dart';

class CvBuilderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeminiService>(() => GeminiService());
    Get.lazyPut<CvBuilderController>(
      () => CvBuilderController(),
    );
  }
}
