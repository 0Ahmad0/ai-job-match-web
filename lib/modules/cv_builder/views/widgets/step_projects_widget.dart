import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/common/custom_button.dart';
import '../../controllers/cv_builder_controller.dart';
import 'add_project_sheet.dart';

class StepProjectsWidget extends GetView<CvBuilderController> {
  const StepProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('lbl_projects'.tr, style: context.textTheme.headlineMedium),
            20.verticalSpace,
            Obx(() => Expanded(
              child: controller.projects.isEmpty
                  ? Center(child: Text("No projects added yet", style: TextStyle(color: Colors.grey, fontSize: 14.sp)))
                  : ListView.builder(
                itemCount: controller.projects.length,
                itemBuilder: (ctx, i) {
                  final project = controller.projects[i];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: ListTile(
                      leading: const Icon(Icons.folder_open),
                      title: Text(project.name),
                      subtitle: Text(project.year),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.projects.removeAt(i),
                      ),
                    ),
                  );
                },
              ),
            )),
            CustomButton(
              text: '+ Add Project',
              color: Colors.grey.shade200,
              textColor: Colors.black,
              onPressed: () => Get.bottomSheet(const AddProjectSheet()),
            ),
          ],
        ),
      ),
    );
  }
}