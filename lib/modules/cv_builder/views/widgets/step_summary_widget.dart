import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/cv_builder_controller.dart';

class StepSummaryWidget extends GetView<CvBuilderController> {
  const StepSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('lbl_summary'.tr, style: context.textTheme.headlineMedium),
            10.verticalSpace,
            Text('hint_summary'.tr, style: context.textTheme.bodyMedium),
            20.verticalSpace,
            TextField(
              controller: controller.summaryCtrl,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "I am a software engineer with 5 years of experience...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                filled: true,
                fillColor: context.isDarkMode ? Colors.white10 : Colors.grey.shade50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}