import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';

class AddExperienceSheet extends GetView<CvBuilderController> {
  const AddExperienceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('btn_add_position'.tr, style: context.textTheme.headlineSmall),
          20.verticalSpace,
          CustomTextField(
            label: 'lbl_job_title'.tr,
            hint: "Software Engineer",
            prefixIcon: Icons.work_outline,
            controller: controller.jobTitleCtrl,
          ),
          20.verticalSpace,
          CustomButton(
            text: 'btn_save'.tr,
            onPressed: controller.addExperience,
          ),
          20.verticalSpace, // مسافة للكيبورد
        ],
      ),
    );
  }
}