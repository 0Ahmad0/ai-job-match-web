import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';

class StepPersonalInfoWidget extends GetView<CvBuilderController> {
  const StepPersonalInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: 'step_personal'.tr,
              subtitle: 'personal_hint'.tr,
            ),
            if (controller.isSectionHighlighted('personal')) ...[
              14.verticalSpace,
              AppStateCard(
                icon: Icons.edit_note,
                title: 'cv_fix_focus_title'.tr,
                message: 'cv_fix_personal_hint'.tr,
              ),
            ],
            24.verticalSpace,
            CustomTextField(
              label: 'lbl_fullname'.tr,
              hint: 'name_hint'.tr,
              prefixIcon: Icons.person_outline,
              controller: controller.nameCtrl,
            ),
            18.verticalSpace,
            CustomTextField(
              label: 'lbl_email'.tr,
              hint: 'email_hint'.tr,
              prefixIcon: Icons.email_outlined,
              controller: controller.emailCtrl,
            ),
            18.verticalSpace,
            CustomTextField(
              label: 'lbl_phone'.tr,
              hint: 'profile_phone_hint'.tr,
              prefixIcon: Icons.phone_outlined,
              controller: controller.phoneCtrl,
            ),
          ],
        ),
      ),
    );
  }
}
