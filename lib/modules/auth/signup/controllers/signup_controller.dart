import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../../../../data/services/auth_service.dart';
import '../../auth_controller.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final aboutYouController = TextEditingController();

  final selectedRole = 0.obs;
  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;

  final AuthController _authController = Get.find<AuthController>();

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmVisibility() => isConfirmHidden.value = !isConfirmHidden.value;

  void selectRole(int roleIndex) {
    selectedRole.value = roleIndex;
  }

  Future<void> signup() async {
    if (selectedRole.value == 0) {
      _showError('select_role_error'.tr);
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    final role = selectedRole.value == 1 ? UserRole.jobSeeker : UserRole.company;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await _authController.register(
      email: emailController.text.trim(),
      password: passwordController.text,
      role: role,
      fullName: nameController.text.trim(),
      companyName: nameController.text.trim(),
      aboutYou: aboutYouController.text.trim().isEmpty ? null : aboutYouController.text.trim(),
    );

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (!success) {
      developer.log(
        'Signup failed with key=${_authController.errorKey} params=${_authController.errorParams}',
        name: 'SignupController',
      );
      _showError(_authController.errorKey.trParams(_authController.errorParams));
      return;
    }

    developer.log('Signup succeeded for role=${role.name}', name: 'SignupController');

    final destination = await _authController.resolveSessionDestination();
    if (destination != null) {
      Get.offAllNamed(
        destination['route'] as String,
        arguments: destination['arguments'],
      );
    }

    _showSuccess(
      role == UserRole.jobSeeker
          ? 'verification_sent'.tr
          : 'registration_success_pending'.tr,
    );
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

  void goToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    aboutYouController.dispose();
    super.onClose();
  }
}

