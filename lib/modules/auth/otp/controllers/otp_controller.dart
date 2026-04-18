import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../routes/app_routes.dart';
import '../../auth_controller.dart';

class OtpController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // محاكاة فتح تطبيق الايميل
  Future<void> openEmailApp() async {
    // Android: intent to open mail app
    // iOS: message://
    // final Uri emailLaunchUri = Uri(scheme: 'mailto');
    // try {
    //   if (await canLaunchUrl(emailLaunchUri)) {
    //     await launchUrl(emailLaunchUri);
    //   } else {
    //     Get.snackbar('Error', 'Could not open email app');
    //   }
    // } catch (e) {
    //   // Fallback
    // }
  }

  Future<void> resendLink() async {
    final success = await _authController.sendEmailVerification();
    if (success) {
      Get.snackbar(
        'success_title'.tr,
        'msg_link_resent'.tr,
        backgroundColor: Colors.green.withValues(alpha: 0.95),
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'err_title'.tr,
      _authController.errorKey.trParams(_authController.errorParams),
      backgroundColor: Colors.red.withValues(alpha: 0.95),
      colorText: Colors.white,
    );
  }

  Future<void> skipToLogin() async {
    await _authController.logout();
    Get.offAllNamed(Routes.AUTH_LOGIN);
  }
}
