import 'package:get/get.dart';
import '../controllers/candidates_controller.dart';

class CandidatesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CandidatesController>()) {
      Get.lazyPut<CandidatesController>(() => CandidatesController());
    }
  }
}

