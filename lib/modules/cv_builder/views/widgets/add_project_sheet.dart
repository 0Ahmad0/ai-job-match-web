import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';
import '../../../../data/models/cv_model.dart';

class AddProjectSheet extends StatefulWidget {
  const AddProjectSheet({super.key});

  @override
  State<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends State<AddProjectSheet> {
  final controller = Get.find<CvBuilderController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('lbl_projects'.tr, style: context.textTheme.headlineSmall),
            20.verticalSpace,
            CustomTextField(
              label: 'lbl_project_name'.tr,
              hint: "e.g. E-Commerce App",
              prefixIcon: Icons.code_outlined,
              controller: TextEditingController(), // سنستخدم متحكم مؤقت
            ),
            15.verticalSpace,
            CustomTextField(
              label: 'lbl_project_desc'.tr,
              hint: "Built using Flutter...",
              prefixIcon: Icons.description_outlined,
              maxLines: 3,
              controller: TextEditingController(),
            ),
            15.verticalSpace,
            CustomTextField(
              label: 'lbl_project_year'.tr,
              hint: "2023",
              prefixIcon: Icons.calendar_today,
              controller: TextEditingController(),
            ),
            15.verticalSpace,
            CustomTextField(
              label: 'lbl_project_url'.tr,
              hint: "https://github.com/...",
              prefixIcon: Icons.link,
              controller: TextEditingController(),
            ),
            20.verticalSpace,
            CustomButton(
              text: 'btn_save'.tr,
              onPressed: () {
                // حفظ المشروع
                controller.projects.add(CvProject(
                  name: controller.projectNameCtrl.text,
                  description: controller.projectDescCtrl.text,
                  year: controller.projectYearCtrl.text,
                  url: controller.projectUrlCtrl.text,
                ));
                // تفريغ الحقول
                controller.projectNameCtrl.clear();
                controller.projectDescCtrl.clear();
                controller.projectYearCtrl.clear();
                controller.projectUrlCtrl.clear();
                Get.back();
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}