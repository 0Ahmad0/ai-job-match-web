import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../controllers/signup_controller.dart';

class SignupFormWidget extends GetView<SignupController> {
  const SignupFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 400),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Full Name
            CustomTextField(
              label: 'full_name'.tr,
              hint: 'name_hint'.tr,
              prefixIcon: Icons.person_outline,
              controller: controller.nameController,
              validator: (value) => (value?.isEmpty ?? true)
                  ? 'err_required_field'.tr
                  : null,
            ),

            16.verticalSpace,

            // Email
            CustomTextField(
              label: 'email_label'.tr,
              hint: 'email_hint'.tr,
              prefixIcon: Icons.email_outlined,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => !GetUtils.isEmail(value ?? '') ? 'email_error'.tr : null,
            ),

            16.verticalSpace,

            // Password
            Obx(() => CustomTextField(
              label: 'pass_label'.tr,
              hint: 'pass_hint'.tr,
              prefixIcon: Icons.lock_outline,
              controller: controller.passwordController,
              isPassword: true,
              obscureText: controller.isPasswordHidden.value,
              onSuffixPressed: controller.togglePasswordVisibility,
              validator: (value) => (value?.length ?? 0) < 6 ? 'pass_error'.tr : null,
            )),

            16.verticalSpace,

            // Confirm Password
            Obx(() => CustomTextField(
              label: 'confirm_pass'.tr,
              hint: 'confirm_pass_hint'.tr,
              prefixIcon: Icons.lock,
              controller: controller.confirmPassController,
              isPassword: true,
              obscureText: controller.isConfirmHidden.value,
              onSuffixPressed: controller.toggleConfirmVisibility,
              validator: (value) {
                if (value != controller.passwordController.text) return 'pass_match_error'.tr;
                return null;
              },
            )),

            16.verticalSpace,

            // About You (Optional)
            CustomTextField(
              label: 'lbl_about_you'.tr,
              hint: 'hint_about_you'.tr,
              prefixIcon: Icons.person_outline_rounded,
              controller: controller.aboutYouController,
              maxLines: 3,
              validator: (value) => null, // Optional field
            ),

            30.verticalSpace,

            // Sign Up Button
            CustomButton(
              text: 'create_account'.tr,
              onPressed: controller.signup,
            ),
          ],
        ),
      ),
    );
  }
}
