import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/common/custom_button.dart';
import '../../controllers/cv_builder_controller.dart';
import 'add_education_sheet.dart';

class StepEducationWidget extends GetView<CvBuilderController> {
  const StepEducationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('step_education'.tr, style: context.textTheme.headlineMedium),
            20.verticalSpace,
            Obx(() => Expanded(
              child: controller.educations.isEmpty
                  ? Center(child: Text("No education added", style: TextStyle(color: Colors.grey, fontSize: 14.sp)))
                  : ListView.builder(
                itemCount: controller.educations.length,
                itemBuilder: (ctx, i) {
                  final edu = controller.educations[i];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(edu.school),
                      subtitle: Text("${edu.degree} - ${edu.year}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removeEducation(i),
                      ),
                    ),
                  );
                },
              ),
            )),
            CustomButton(
              text: 'btn_add_edu'.tr,
              color: Colors.grey.shade200,
              textColor: Colors.black,
              onPressed: () => Get.bottomSheet(const AddEducationSheet()),
            ),
          ],
        ),
      ),
    );
  }
}