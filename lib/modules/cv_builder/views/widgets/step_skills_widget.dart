import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/cv_builder_controller.dart';
import 'add_skill_sheet.dart';

class StepSkillsWidget extends GetView<CvBuilderController> {
  const StepSkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('step_skills'.tr, style: context.textTheme.headlineMedium),
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.skillCtrl,
                      decoration: InputDecoration(
                        hintText: 'skill_hint'.tr,
                        prefixIcon: const Icon(Icons.star_outline),
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  ElevatedButton(
                    onPressed: () => Get.bottomSheet(const AddSkillSheet(), isScrollControlled: true),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(12.r),
                      backgroundColor: context.theme.primaryColor,
                      minimumSize: Size(52.w, 52.w),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              20.verticalSpace,
              if (controller.isSectionHighlighted('skills'))
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Text('cv_fix_skills_hint'.tr, style: context.textTheme.bodyMedium),
                ),
              20.verticalSpace,
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.skillsList
                      .map(
                        (skill) => Chip(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              '${skill.name} (${_getSkillLevel(skill.level)})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => controller.removeSkill(skill),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSkillLevel(int level) {
    switch (level) {
      case 1:
        return 'level_beginner'.tr;
      case 2:
        return 'level_junior'.tr;
      case 3:
        return 'level_intermediate'.tr;
      case 4:
        return 'level_senior'.tr;
      case 5:
        return 'level_expert'.tr;
      default:
        return '';
    }
  }
}
