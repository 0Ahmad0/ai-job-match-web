import 'package:get/get.dart';
import '../controllers/ai_analyzer_controller.dart';

class AiAnalyzerBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AiAnalyzerController>()) {
      Get.lazyPut<AiAnalyzerController>(() => AiAnalyzerController());
    }
  }
}

