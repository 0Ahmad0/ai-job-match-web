import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/common/custom_button.dart';
import '../../../../core/common/shimmer_skeletons.dart';
import '../../../../core/common/custom_text_field.dart';
import '../controllers/post_job_controller.dart';

class PostJobView extends GetView<PostJobController> {
  const PostJobView({super.key});

  @override
  Widget build(BuildContext context) {
    // الحقن (يمكن نقله للـ Binding)
    

    return Scaffold(
      appBar: AppBar(title: Text('lbl_post_job'.tr), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            // Progress Indicator
            Obx(
              () => Row(
                children: [
                  _buildStepIndicator(
                    context,
                    1,
                    'step_job_details'.tr,
                    controller.currentStep.value >= 0,
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade300, thickness: 2),
                  ),
                  _buildStepIndicator(
                    context,
                    2,
                    'step_desc'.tr,
                    controller.currentStep.value >= 1,
                  ),
                ],
              ),
            ),

            30.verticalSpace,

            // Content Area
            Expanded(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: controller.currentStep.value == 0
                      ? _buildStep1(context)
                      : _buildStep2(context),
                ),
              ),
            ),

            // Navigation Buttons
            Obx(
              () => Row(
                children: [
                  if (controller.currentStep.value > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.prevStep,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          side: BorderSide(color: context.theme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text('btn_back'.tr),
                      ),
                    ),
                  if (controller.currentStep.value > 0) 15.horizontalSpace,
                    Expanded(
                      child: controller.isPublishing.value
                          ? const ShimmerSkeleton(height: 50, radius: 12)
                          : CustomButton(
                              text: controller.currentStep.value == 0
                                  ? 'btn_next'.tr
                                  : 'lbl_publish'.tr,
                              onPressed: controller.nextStep,
                            ),
                    ),
                  ],
              ).animate().fade(duration: 280.ms).slideY(begin: 0.04, end: 0),
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 1: Basics ---
  Widget _buildStep1(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'lbl_job_title_input'.tr,
            hint: '',
            prefixIcon: Icons.work_outline,
            controller: controller.titleCtrl,
          ),
          20.verticalSpace,

          Text(
            'lbl_job_type_select'.tr,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          10.verticalSpace,
          Obx(
            () => Wrap(
              spacing: 10,
              children: controller.jobTypes.map((type) {
                final isSelected = controller.selectedJobType.value == type;
                return ChoiceChip(
                  label: Text(type == 'Full Time' ? 'lbl_full_time'.tr : type == 'Part Time' ? 'lbl_part_time'.tr : type == 'Remote' ? 'lbl_remote'.tr : type == 'Contract' ? 'lbl_contract'.tr : type),
                  selected: isSelected,
                  onSelected: (val) => controller.selectedJobType.value = type,
                  selectedColor: context.theme.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ),

          20.verticalSpace,
          CustomTextField(
            label: 'lbl_location_input'.tr,
            hint: 'hint_location_input'.tr,
            prefixIcon: Icons.location_on_outlined,
            controller: controller.locationCtrl,
          ),

          20.verticalSpace,
          Text(
            'lbl_salary_range'.tr,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: '',
                  hint: 'hint_min_salary'.tr,
                  prefixIcon: Icons.attach_money,
                  controller: controller.minSalaryCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: CustomTextField(
                  label: '',
                  hint: 'hint_max_salary'.tr,
                  prefixIcon: Icons.attach_money,
                  controller: controller.maxSalaryCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          20.verticalSpace,
          Text(
            'job_required_skills'.tr,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.skillInputCtrl,
                  onSubmitted: (_) => controller.addSkillFromInput(),
                  decoration: InputDecoration(
                    hintText: 'job_skill_input_hint'.tr,
                    prefixIcon: const Icon(Icons.psychology_alt_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              10.horizontalSpace,
              ElevatedButton(
                onPressed: controller.addSkillFromInput,
                child: Text('btn_add'.tr),
              ),
            ],
          ),
          10.verticalSpace,
          Obx(
            () => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.requiredSkills
                  .map(
                    (skill) => Chip(
                      label: Text(skill),
                      onDeleted: () => controller.removeSkill(skill),
                      deleteIcon: const Icon(Icons.close),
                    ),
                  )
                  .toList(),
            ),
          ),
          6.verticalSpace,
          Obx(
            () => Text(
              'job_skills_count'.trParams({
                'count': controller.requiredSkills.length.toString(),
              }),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 2: Description & AI ---
  Widget _buildStep2(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey(2),
      child: Column(
        children: [
          // AI Button
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: controller.isAiWriting.value
                  ? null
                  : controller.autoWriteDescription,
              icon: controller.isAiWriting.value
                  ? SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text('lbl_ai_write'.tr),
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
            ),
          ),

          TextField(
            controller: controller.descriptionCtrl,
            maxLines: 15,
            decoration: InputDecoration(
              hintText: 'lbl_job_desc_hint'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              filled: true,
              fillColor: context.isDarkMode
                  ? Colors.white10
                  : Colors.grey.shade50,
              contentPadding: EdgeInsets.all(20.r),
            ),
          ),
          14.verticalSpace,
          Obx(
            () => controller.aiRequirements.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: context.theme.primaryColor.withValues(alpha: 0.08),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'lbl_requirements'.tr,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        8.verticalSpace,
                        ...controller.aiRequirements
                            .take(6)
                            .map((req) => Padding(
                                  padding: EdgeInsets.only(bottom: 6.h),
                                  child: Text('- $req'),
                                )),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
    BuildContext context,
    int step,
    String label,
    bool isActive,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15.r,
          backgroundColor: isActive
              ? context.theme.primaryColor
              : Colors.grey.shade300,
          child: Text(
            step.toString(),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        5.verticalSpace,
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isActive ? context.theme.primaryColor : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}


