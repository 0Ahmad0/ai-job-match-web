// استبدل محتوى ملف step_skills_widget.dart بهذا:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/cv_builder_controller.dart';
import 'add_skill_sheet.dart';

class StepSkillsWidget extends GetView<CvBuilderController> {
  const StepSkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('step_skills'.tr, style: context.textTheme.headlineMedium),
            20.verticalSpace,

            // Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.skillCtrl,
                    decoration: InputDecoration(
                      hintText: "e.g. Flutter",
                      prefixIcon: const Icon(Icons.star_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                  ),
                ),
                10.horizontalSpace,
                ElevatedButton(
                  onPressed: () => Get.bottomSheet(const AddSkillSheet()),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(12.r),
                    backgroundColor: context.theme.primaryColor,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),

            30.verticalSpace,

            // Chips Display
            Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.skillsList.map((skill) => Chip(
                label: Text("${skill.name} (${_getSkillLevel(skill.level)})"),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => controller.removeSkill(skill),
                backgroundColor: context.theme.primaryColor.withValues(alpha: 0.1),
              )).toList(),
            )),
          ],
        ),
      ),
    );
  }

  String _getSkillLevel(int level) {
    switch (level) {
      case 1: return 'level_beginner'.tr;
      case 2: return 'level_junior'.tr;
      case 3: return 'level_intermediate'.tr;
      case 4: return 'level_senior'.tr;
      case 5: return 'level_expert'.tr;
      default: return '';
    }
  }
}