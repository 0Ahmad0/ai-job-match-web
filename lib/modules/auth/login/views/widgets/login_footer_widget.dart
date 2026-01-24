import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/login_controller.dart';

class LoginFooterWidget extends GetView<LoginController> {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'dont_have_account'.tr,
            style: context.textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: controller.goToSignup,
            child: Text(
              'signup_link'.tr,
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