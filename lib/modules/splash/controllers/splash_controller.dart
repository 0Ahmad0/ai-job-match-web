import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // محاكاة لعملية تحميل بيانات أو فحص
    await Future.delayed(const Duration(seconds: 4));

    Get.offNamed(Routes.ONBOARDING);
    print("Go to Next Page");
  }
}