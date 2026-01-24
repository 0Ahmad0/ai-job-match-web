import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';

class StepPersonalInfoWidget extends GetView<CvBuilderController> {
  const StepPersonalInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight( // انميشن عند الدخول
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('step_personal'.tr, style: context.textTheme.headlineMedium),
            10.verticalSpace,
            Text('personal_hint'.tr, style: context.textTheme.bodyMedium),
            30.verticalSpace,
            CustomTextField(
              label: 'lbl_fullname'.tr,
              hint: "ex: Ahmed Ali",
              prefixIcon: Icons.person_outline,
              controller: controller.nameCtrl,
            ),
            20.verticalSpace,
            CustomTextField(
              label: 'lbl_email'.tr,
              hint: "ex: ahmed@mail.com",
              prefixIcon: Icons.email_outlined,
              controller: controller.emailCtrl,
            ),
            20.verticalSpace,
            CustomTextField(
              label: 'lbl_phone'.tr,
              hint: "+966...",
              prefixIcon: Icons.phone_outlined,
              controller: controller.phoneCtrl,
            ),
          ],
        ),
      ),
    );
  }
}