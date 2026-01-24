import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/signup_controller.dart';

class SignupFooterWidget extends GetView<SignupController> {
  const SignupFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'already_have_account'.tr,
            style: context.textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: controller.goToLogin,
            child: Text(
              'login_btn'.tr,
              style: TextStyle(
                color: context.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}