import 'dart:math' as math;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/common/custom_button.dart';
import '../../controllers/cv_builder_controller.dart';

class StepTemplateSelectorWidget extends GetView<CvBuilderController> {
  const StepTemplateSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: 'title_choose_template'.tr,
              subtitle: 'subtitle_template'.tr,
            ),
            20.verticalSpace,
            LayoutBuilder(
              builder: (context, constraints) {
                final optionWidth = math.min(220.w, constraints.maxWidth);
                return Wrap(
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: [
                    _buildOption(context, 1, 'tpl_modern'.tr, Icons.article_outlined, optionWidth),
                    _buildOption(context, 2, 'tpl_classic'.tr, Icons.description_outlined, optionWidth),
                    _buildOption(context, 3, 'tpl_clean'.tr, Icons.format_align_left, optionWidth),
                  ],
                );
              },
            ),
            22.verticalSpace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: context.theme.primaryColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('cv_preview_ready_title'.tr, style: context.textTheme.titleMedium),
                  8.verticalSpace,
                  Text('cv_preview_ready_desc'.tr, style: context.textTheme.bodyMedium),
                ],
              ),
            ),
            24.verticalSpace,
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 420;
                final saveButton = OutlinedButton(
                  onPressed: controller.saveDraft,
                  child: Text('cv_save_draft'.tr, overflow: TextOverflow.ellipsis),
                );
                final previewButton = CustomButton(
                  text: 'cv_preview_cta'.tr,
                  onPressed: controller.previewPdf,
                );

                if (isCompact) {
                  return Column(
                    children: [
                      SizedBox(width: double.infinity, child: saveButton),
                      10.verticalSpace,
                      SizedBox(width: double.infinity, child: previewButton),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: saveButton),
                    12.horizontalSpace,
                    Expanded(child: previewButton),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    int index,
    String name,
    IconData icon,
    double width,
  ) {
    return Obx(() {
      final isSelected = controller.selectedTemplate.value == index;
      final primary = context.theme.primaryColor;

      return GestureDetector(
        onTap: () => controller.selectTemplate(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: width,
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: isSelected ? primary.withValues(alpha: 0.08) : context.theme.cardColor,
            border: Border.all(color: isSelected ? primary : context.theme.dividerColor, width: isSelected ? 1.5 : 1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: isSelected ? primary.withValues(alpha: 0.14) : Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(icon, size: 26.sp, color: isSelected ? primary : Colors.grey),
              ),
              14.verticalSpace,
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? primary : null),
              ),
              6.verticalSpace,
              Text(
                'cv_template_card_desc'.tr,
                style: context.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }
}
