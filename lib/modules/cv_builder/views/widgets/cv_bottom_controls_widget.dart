import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/custom_button.dart';
import '../../controllers/cv_builder_controller.dart';

class CvBottomControlsWidget extends GetView<CvBuilderController> {
  const CvBottomControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر الرجوع
          TextButton(
            onPressed: controller.prevStep,
            child: Text(
              'btn_back'.tr,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),

          // زر التالي (يختفي في آخر خطوة)
          Obx(() {
            // ملاحظة: افترضنا أن رقم آخر خطوة هو 4 (Template Step)
            if (controller.currentStep.value == 5) return const SizedBox.shrink();

            return CustomButton(
              width: 120.w,
              height: 45.h,
              text: 'btn_next'.tr,
              onPressed: controller.nextStep,
            );
          }),
        ],
      ),
    );
  }
}