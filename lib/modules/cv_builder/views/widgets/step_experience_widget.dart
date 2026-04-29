import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/common/custom_button.dart';
import '../../controllers/cv_builder_controller.dart';
import 'add_experience_sheet.dart';

class StepExperienceWidget extends GetView<CvBuilderController> {
  const StepExperienceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('step_experience'.tr, style: context.textTheme.headlineMedium),
              20.verticalSpace,
              if (controller.isSectionHighlighted('experience')) ...[
                AppStateCard(
                  icon: Icons.work_history_outlined,
                  title: 'cv_fix_focus_title'.tr,
                  message: 'experience_hint'.tr,
                ),
                14.verticalSpace,
              ],

              Obx(() {
                if (controller.experiences.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: Text(
                        'no_exp_added'.tr,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.experiences.length,
                  itemBuilder: (ctx, i) {
                    final exp = controller.experiences[i];
                    return Card(
                      margin: EdgeInsets.only(bottom: 10.h),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: context.theme.primaryColor.withValues(alpha: 0.1),
                          child: Icon(Icons.work, color: context.theme.primaryColor),
                        ),
                        title: Text(exp.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(exp.company),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => controller.experiences.removeAt(i),
                        ),
                      ),
                    );
                  },
                );
              }),

              20.verticalSpace,

              // زر الإضافة
              CustomButton(
                text: 'btn_add_position'.tr,
                color: context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                textColor: context.isDarkMode ? Colors.white : Colors.black,
                onPressed: () {
                  Get.bottomSheet(const AddExperienceSheet(), isScrollControlled: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
