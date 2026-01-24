import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../controllers/post_job_controller.dart';

class PostJobView extends GetView<PostJobController> {
  const PostJobView({super.key});

  @override
  Widget build(BuildContext context) {
    // الحقن (يمكن نقله للـ Binding)
    Get.put(PostJobController());

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
                    child: CustomButton(
                      text: controller.currentStep.value == 0
                          ? 'btn_next'.tr
                          : 'lbl_publish'.tr,
                      onPressed: controller.nextStep,
                    ),
                  ),
                ],
              ),
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
                  label: Text(type),
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
            hint: 'New York, Remote...',
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
                  hint: 'Min (e.g. 2000)',
                  prefixIcon: Icons.attach_money,
                  controller: controller.minSalaryCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: CustomTextField(
                  label: '',
                  hint: 'Max (e.g. 5000)',
                  prefixIcon: Icons.attach_money,
                  controller: controller.maxSalaryCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
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
