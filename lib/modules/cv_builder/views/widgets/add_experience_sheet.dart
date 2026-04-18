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
      padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 20.r + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('btn_add_position'.tr, style: context.textTheme.headlineSmall),
              20.verticalSpace,
              CustomTextField(
                label: 'lbl_job_title'.tr,
                hint: 'Software Engineer',
                prefixIcon: Icons.work_outline,
                controller: controller.expJobTitleCtrl,
              ),
              14.verticalSpace,
              CustomTextField(
                label: 'lbl_company'.tr,
                hint: 'Google',
                prefixIcon: Icons.business_outlined,
                controller: controller.companyCtrl,
              ),
              14.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'start_date'.tr,
                      hint: '2022',
                      prefixIcon: Icons.event_outlined,
                      controller: controller.expStartCtrl,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: CustomTextField(
                      label: 'end_date'.tr,
                      hint: 'Present',
                      prefixIcon: Icons.event_available_outlined,
                      controller: controller.expEndCtrl,
                    ),
                  ),
                ],
              ),
              14.verticalSpace,
              CustomTextField(
                label: 'description'.tr,
                hint: 'Led mobile app development...',
                maxLines: 4,
                prefixIcon: Icons.notes_outlined,
                controller: controller.expDescCtrl,
              ),
              20.verticalSpace,
              CustomButton(
                text: 'btn_save'.tr,
                onPressed: controller.addExperience,
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
