import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_button.dart';
import '../../controllers/cv_builder_controller.dart';

class CvBottomControlsWidget extends GetView<CvBuilderController> {
  const CvBottomControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery for stability instead of LayoutBuilder during build/layout transitions
    final isCompact = MediaQuery.of(context).size.width < 460;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: isCompact ? _buildCompact(context) : _buildStandard(context),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _backButton(),
          ],
        ),
        10.verticalSpace,
        SizedBox(width: double.infinity, child: _nextButton(true)),
      ],
    );
  }

  Widget _buildStandard(BuildContext context) {
    return Row(
      children: [
        _backButton(),
        const Spacer(),
        _nextButton(false),
      ],
    );
  }

  Widget _backButton() {
    return TextButton(
      onPressed: controller.prevStep,
      child: Text('btn_back'.tr, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
    );
  }

  Widget _nextButton(bool isFullWidth) {
    return Obx(() {
      final isLastStep = controller.currentStep.value == controller.totalSteps - 1;
      return CustomButton(
        isFullWidth: isFullWidth,
        width: isFullWidth ? null : 170.w,
        height: 46.h,
        text: isLastStep ? 'cv_finish'.tr : 'btn_next'.tr,
        onPressed: isLastStep ? controller.finalizeCvAndGoHome : controller.nextStep,
      );
    });
  }
}
