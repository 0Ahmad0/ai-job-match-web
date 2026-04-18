import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth_controller.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();

  Future<void> sendResetLink() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final sent = await _authController.sendPasswordResetEmail(
      emailController.text.trim(),
    );

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (!sent) {
      _showError(_authController.errorKey.trParams(_authController.errorParams));
      return;
    }

    _showSuccess('reset_link_sent'.tr);
  }

  void _showError(String message) {
    Get.snackbar(
      'err_title'.tr,
      message,
      backgroundColor: Colors.red.withValues(alpha: 0.95),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'success_title'.tr,
      message,
      backgroundColor: Colors.green.withValues(alpha: 0.95),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

