import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';

class AddProjectSheet extends GetView<CvBuilderController> {
  const AddProjectSheet({super.key});

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
              Text('lbl_projects'.tr, style: context.textTheme.headlineSmall),
              20.verticalSpace,
              CustomTextField(
                label: 'lbl_project_name'.tr,
                hint: 'lbl_project_name'.tr,
                prefixIcon: Icons.code_outlined,
                controller: controller.projectNameCtrl,
              ),
              15.verticalSpace,
              CustomTextField(
                label: 'lbl_project_desc'.tr,
                hint: 'lbl_project_desc'.tr,
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
                controller: controller.projectDescCtrl,
              ),
              15.verticalSpace,
              CustomTextField(
                label: 'lbl_project_year'.tr,
                hint: 'lbl_project_year'.tr,
                prefixIcon: Icons.calendar_today,
                controller: controller.projectYearCtrl,
              ),
              15.verticalSpace,
              CustomTextField(
                label: 'lbl_project_url'.tr,
                hint: 'lbl_project_url'.tr,
                prefixIcon: Icons.link,
                controller: controller.projectUrlCtrl,
              ),
              20.verticalSpace,
              CustomButton(
                text: 'btn_save'.tr,
                onPressed: controller.addProject,
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
