import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/cv_builder_controller.dart';

class StepSummaryWidget extends GetView<CvBuilderController> {
  const StepSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: 'lbl_summary'.tr,
              subtitle: 'hint_summary'.tr,
            ),
            if (controller.isSectionHighlighted('summary')) ...[
              14.verticalSpace,
              AppStateCard(
                icon: Icons.auto_awesome,
                title: 'cv_fix_focus_title'.tr,
                message: 'hint_summary'.tr,
              ),
            ],
            if (controller.aiSuggestions.isNotEmpty) ...[
              14.verticalSpace,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('cv_ai_suggestions_title'.tr, style: context.textTheme.titleMedium),
                    8.verticalSpace,
                    ...controller.aiSuggestions.take(3).map(
                      (tip) => Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.auto_awesome, size: 16.sp, color: context.theme.primaryColor),
                            8.horizontalSpace,
                            Expanded(child: Text(tip, style: context.textTheme.bodyMedium)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            20.verticalSpace,
            CustomTextField(
              label: 'lbl_job_title'.tr,
              hint: 'profile_headline_hint'.tr,
              prefixIcon: Icons.badge_outlined,
              controller: controller.jobTitleCtrl,
            ),
            18.verticalSpace,
            CustomTextField(
              label: 'lbl_summary'.tr,
              hint: 'hint_summary'.tr,
              prefixIcon: Icons.notes_outlined,
              controller: controller.summaryCtrl,
              maxLines: 8,
            ),
          ],
        ),
      ),
    );
  }
}
