import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/common/custom_button.dart';
import '../../controllers/cv_builder_controller.dart';

class StepTemplateSelectorWidget extends GetView<CvBuilderController> {
  const StepTemplateSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Text(
              'title_choose_template'.tr,
              style: context.textTheme.headlineMedium,
            ),
            10.verticalSpace,
            Text('subtitle_template'.tr, style: context.textTheme.bodyMedium),
            40.verticalSpace,

            // خيارات القوالب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOption(
                  context,
                  1,
                  'tpl_modern'.tr,
                  Icons.article_outlined,
                ),
                _buildOption(
                  context,
                  2,
                  'tpl_classic'.tr,
                  Icons.description_outlined,
                ),
                _buildOption(
                  context,
                  3,
                  'tpl_clean'.tr,
                  Icons.format_align_left,
                ),
              ],
            ),

            const Spacer(),

            // زر التحميل
            CustomButton(
              text: 'btn_download_pdf'.tr,
              color: Colors.green,
              onPressed: controller.generatePdf,
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
  ) {
    return Obx(() {
      final isSelected = controller.selectedTemplate.value == index;
      final primary = context.theme.primaryColor;

      return GestureDetector(
        onTap: () => controller.selectTemplate(index),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 90.w,
              height: 110.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.1)
                    : context.theme.cardColor,
                border: Border.all(
                  color: isSelected ? primary : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 40.sp,
                color: isSelected ? primary : Colors.grey,
              ),
            ),
            10.verticalSpace,
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? primary : Colors.grey,
              ),
            ),
          ],
        ),
      );
    });
  }
}
