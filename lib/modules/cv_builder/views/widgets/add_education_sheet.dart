import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';

class AddEducationSheet extends GetView<CvBuilderController> {
  const AddEducationSheet({super.key});

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
          Text('btn_add_edu'.tr, style: context.textTheme.headlineSmall),
          20.verticalSpace,
          CustomTextField(label: 'lbl_school'.tr, hint: "University...", prefixIcon: Icons.school_outlined, controller: controller.schoolCtrl),
          15.verticalSpace,
          CustomTextField(label: 'lbl_degree'.tr, hint: "Bachelor's...", prefixIcon: Icons.history_edu, controller: controller.degreeCtrl),
          15.verticalSpace,
          CustomTextField(label: 'lbl_year'.tr, hint: "2023", prefixIcon: Icons.calendar_today, controller: controller.eduYearCtrl),
          20.verticalSpace,
          CustomButton(text: 'btn_save'.tr, onPressed: controller.addEducation),
          20.verticalSpace,
        ],
      ),
    );
  }
}