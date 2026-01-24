import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';
import '../../../../data/models/cv_model.dart';

class AddSkillSheet extends StatefulWidget {
  const AddSkillSheet({super.key});

  @override
  State<AddSkillSheet> createState() => _AddSkillSheetState();
}

class _AddSkillSheetState extends State<AddSkillSheet> {
  final controller = Get.find<CvBuilderController>();
  int selectedLevel = 1;

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
          Text('Add Skill', style: context.textTheme.headlineSmall),
          20.verticalSpace,
          CustomTextField(
            label: 'lbl_skill'.tr,
            hint: "e.g. Flutter",
            prefixIcon: Icons.star_outline,
            controller: controller.skillCtrl,
          ),
          20.verticalSpace,
          // اختيار مستوى المهارة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('lbl_skill_level'.tr, style: context.textTheme.bodyMedium),
              Obx(
                () => DropdownButton<int>(
                  value: selectedLevel,
                  items: [1, 2, 3, 4, 5]
                      .map(
                        (level) => DropdownMenuItem(
                          value: level,
                          child: Text(_getSkillLevelText(level)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedLevel = value);
                    }
                  },
                ),
              ),
            ],
          ),
          20.verticalSpace,
          CustomButton(
            text: 'btn_save'.tr,
            onPressed: () {
              if (controller.skillCtrl.text.isNotEmpty) {
                // إضافة المهارة مع المستوى
                controller.skillsList.add(
                  CvSkill(
                    name: controller.skillCtrl.text,
                    level: selectedLevel,
                  ),
                );
                controller.skillCtrl.clear();
                Get.back();
              }
            },
          ),
          20.verticalSpace,
        ],
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
