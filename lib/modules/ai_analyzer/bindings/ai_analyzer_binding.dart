import 'package:get/get.dart';
import '../controllers/ai_analyzer_controller.dart';

class AiAnalyzerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiAnalyzerController>(
      () => AiAnalyzerController(),
    );
  }
}
