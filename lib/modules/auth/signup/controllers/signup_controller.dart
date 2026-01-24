import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  // 0: None, 1: Job Seeker, 2: Employer
  final selectedRole = 0.obs;

  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmVisibility() => isConfirmHidden.value = !isConfirmHidden.value;

  void selectRole(int roleIndex) {
    selectedRole.value = roleIndex;
  }

  void signup() {
    if (selectedRole.value == 0) {
      Get.snackbar(
        'Alert',
        'select_role_error'.tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      // محاكاة عملية التسجيل
      Get.snackbar(
        'Success',
        'Creating account...',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // هنا لاحقاً سنرسل البيانات + selectedRole للـ API
    }
  }

  void goToLogin() {
    Get.back(); // العودة لصفحة الـ Login
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}