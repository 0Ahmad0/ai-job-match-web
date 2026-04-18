import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';

class AddSkillSheet extends StatelessWidget {
  const AddSkillSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CvBuilderController>();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('btn_add_skill'.tr, style: context.textTheme.headlineSmall),
              20.verticalSpace,
              CustomTextField(
                label: 'lbl_skill'.tr,
                hint: 'skill_hint'.tr,
                prefixIcon: Icons.star_outline,
                controller: controller.skillCtrl,
              ),
              20.verticalSpace,
              Text('lbl_skill_level'.tr, style: context.textTheme.bodyMedium),
              8.verticalSpace,
              Obx(
                () => DropdownButtonFormField<int>(
                  isExpanded: true,
                  value: controller.selectedSkillLevel.value,
                  items: [1, 2, 3, 4, 5]
                      .map(
                        (level) => DropdownMenuItem<int>(
                          value: level,
                          child: Text(_getSkillLevelText(level), overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedSkillLevel.value = value;
                    }
                  },
                ),
              ),
              20.verticalSpace,
              CustomButton(
                text: 'btn_save'.tr,
                onPressed: () {
                  if (controller.skillCtrl.text.trim().isNotEmpty) {
                    controller.addSkill();
                    Get.back();
                  }
                },
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  String _getSkillLevelText(int level) {
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
