import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // للتحكم في إظهار/إخفاء كلمة المرور
  final isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() {
    if (formKey.currentState!.validate()) {
      // محاكاة عملية تسجيل الدخول
      Get.snackbar(
        'Success',
        'Logging in...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // هنا سيتم الاتصال بالـ API لاحقاً
      // بعد النجاح ننتقل للصفحة الرئيسية
      // Get.offAllNamed(Routes.HOME);
    }
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