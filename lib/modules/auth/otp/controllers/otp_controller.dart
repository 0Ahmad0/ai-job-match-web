import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../../../routes/app_routes.dart';
import '../../auth_controller.dart';

class OtpController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final isCheckingVerification = false.obs;
  Timer? _pollTimer;
  bool _isNavigating = false;

  @override
  void onReady() {
    super.onReady();
    _checkVerificationAndNavigate();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _checkVerificationAndNavigate(),
    );
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

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

  Future<void> manualRefreshStatus() async {
    await _checkVerificationAndNavigate(showFailureMessage: true);
  }

  Future<void> _checkVerificationAndNavigate({bool showFailureMessage = false}) async {
    if (_isNavigating || isCheckingVerification.value) {
      return;
    }

    isCheckingVerification.value = true;
    try {
      await _authController.refreshCurrentUser();
      final destination = await _authController.resolveSessionDestination();
      if (destination == null) {
        return;
      }

      final route = destination['route'] as String?;
      if (route == null) {
        return;
      }

      if (route != Routes.AUTH_OTP) {
        _isNavigating = true;
        _pollTimer?.cancel();
        Get.offAllNamed(
          route,
          arguments: destination['arguments'],
        );
        return;
      }

      if (showFailureMessage) {
        Get.snackbar(
          'err_title'.tr,
          'check_email_spam_hint'.tr,
          backgroundColor: Colors.orange.withValues(alpha: 0.95),
          colorText: Colors.white,
        );
      }
    } finally {
      isCheckingVerification.value = false;
    }
  }

  Future<void> skipToLogin() async {
    await _authController.logout();
    Get.offAllNamed(Routes.AUTH_LOGIN);
  }
}
