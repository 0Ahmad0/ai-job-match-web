import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../../../../routes/app_routes.dart';
import '../../auth_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  final AuthController _authController = Get.find<AuthController>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await _authController.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (!success) {
      developer.log(
        'Login failed with key=${_authController.errorKey} params=${_authController.errorParams}',
        name: 'LoginController',
      );
      _showAuthError(_authController.errorKey.trParams(_authController.errorParams));
      return;
    }

    final destination = await _authController.resolveSessionDestination();
    if (destination == null) {
      _showAuthError('auth_err_role_not_found'.tr);
      return;
    }

    developer.log(
      'Login destination route=${destination['route']} args=${destination['arguments']}',
      name: 'LoginController',
    );
    Get.offAllNamed(
      destination['route'] as String,
      arguments: destination['arguments'],
    );
  }

  void _showAuthError(String message) {
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

  void goToSignup() {
    Get.toNamed(Routes.AUTH_SIGNUP);
  }

  void goToForgetPassword() {
    Get.toNamed(Routes.AUTH_FORGET_PASSWORD);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

