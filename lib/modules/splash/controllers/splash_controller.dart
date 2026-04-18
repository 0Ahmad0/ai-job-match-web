import 'dart:developer' as developer;

import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../auth/auth_controller.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  
  final RxBool isSessionCheckLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    try {
      isSessionCheckLoading.value = true;
      
      // Add small delay for splash screen visibility
      await Future.delayed(const Duration(seconds: 2));

      developer.log(
        'SplashController: Checking session destination',
        name: 'SplashController',
      );
      
      final destination = await _authController.resolveSessionDestination();
      developer.log(
        'Splash destination=$destination',
        name: 'SplashController',
      );

      if (destination != null) {
        Get.offAllNamed(
          destination['route'] as String,
          arguments: destination['arguments'],
        );
        return;
      }

      Get.offNamed(Routes.ONBOARDING);
    } catch (e, stackTrace) {
      developer.log(
        'Error during session check: $e',
        name: 'SplashController',
        error: e,
        stackTrace: stackTrace,
      );
      Get.offNamed(Routes.ONBOARDING);
    } finally {
      isSessionCheckLoading.value = false;
    }
  }
}
