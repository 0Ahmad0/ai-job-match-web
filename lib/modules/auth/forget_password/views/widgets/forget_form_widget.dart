import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../../core/common/custom_button.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../controllers/forget_password_controller.dart';

class ForgetFormWidget extends GetView<ForgetPasswordController> {
  const ForgetFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 200),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'email_label'.tr,
              hint: 'email_hint'.tr,
              prefixIcon: Icons.email_outlined,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => !GetUtils.isEmail(value ?? '') ? 'email_error'.tr : null,
            ),
            40.verticalSpace,
            CustomButton(
              text: 'send_link_btn'.tr,
              onPressed: controller.sendResetLink,
            ),
          ],
        ),
      ),
    );
  }
}