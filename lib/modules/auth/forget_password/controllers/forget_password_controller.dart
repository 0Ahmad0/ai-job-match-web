import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void sendResetLink() async {
    if (formKey.currentState!.validate()) {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await Future.delayed(const Duration(seconds: 2));
      Get.back(); // إغلاق اللودينج

      Get.toNamed(Routes.AUTH_OTP);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}