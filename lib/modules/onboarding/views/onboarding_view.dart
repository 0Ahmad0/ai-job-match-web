import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/common/custom_button.dart';
import '../controllers/onboarding_controller.dart';
import 'widgets/onboarding_page_widget.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // زر تخطي بسيط
          TextButton(
            onPressed: controller.nextPage,
            child: Text(
              'skip'.tr,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.primaryColor,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) => OnboardingPageWidget(
                  model: controller.pages[index],
                  index: index,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: context.theme.primaryColor,
                      dotColor: context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                    ),
                  ),
                  20.verticalSpace,
                  Obx(() {
                    final isLast = controller.currentPage.value == controller.pages.length - 1;
                    return CustomButton(
                      width: context.width/2,
                      height: 52.h,
                      text: isLast ? 'get_started'.tr : 'next'.tr,
                      onPressed: controller.nextPage,
                      icon: isLast ? null : const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}