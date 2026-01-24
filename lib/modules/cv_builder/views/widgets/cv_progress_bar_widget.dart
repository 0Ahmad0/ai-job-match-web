import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/cv_builder_controller.dart';

class CvProgressBarWidget extends GetView<CvBuilderController> {
  const CvProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      color: context.theme.scaffoldBackgroundColor,
      child: Row(
        children: List.generate(controller.totalSteps, (index) {
          final isActive = index <= controller.currentStep.value;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 6.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: isActive ? context.theme.primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          );
        }),
      ),
    ));
  }
}