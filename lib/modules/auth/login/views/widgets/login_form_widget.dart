import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../controllers/login_controller.dart';

class LoginFormWidget extends GetView<LoginController> {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 200),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Email
            CustomTextField(
              label: 'email_label'.tr,
              hint: 'email_hint'.tr,
              prefixIcon: Icons.email_outlined,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  !GetUtils.isEmail(value ?? '') ? 'email_error'.tr : null,
            ),

            20.verticalSpace,

            // Password
            Obx(
              () => CustomTextField(
                label: 'pass_label'.tr,
                hint: 'pass_hint'.tr,
                prefixIcon: Icons.lock_outline,
                controller: controller.passwordController,
                isPassword: true,
                obscureText: controller.isPasswordHidden.value,
                onSuffixPressed: controller.togglePasswordVisibility,
                validator: (value) =>
                    (value?.length ?? 0) < 6 ? 'pass_error'.tr : null,
              ),
            ),

            // Forgot Password
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: controller.goToForgetPassword,
                child: Text(
                  'forgot_pass'.tr,
                  style: TextStyle(
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),

            20.verticalSpace,

            // Button
            CustomButton(
                text: 'login_btn'.tr, onPressed: controller.login),
          ],
        ),
      ),
    );
  }
}
