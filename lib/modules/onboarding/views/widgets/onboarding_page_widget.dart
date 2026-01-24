import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import '../../../../data/models/onboarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingModel model;
  final int index;

  const OnboardingPageWidget({
    super.key,
    required this.model,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Animation
          ZoomIn(
            key: ValueKey('img_$index'),
            duration: const Duration(milliseconds: 800),
            child: Container(
              height: 300.h,
              width: 300.h,
              decoration: BoxDecoration(
                color: context.theme.primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work,
                size: 100.sp,
                color: context.theme.primaryColor,
              ),
            ),
          ),

          40.verticalSpace,

          // Title: استخدام ستايل الثيم مباشرة
          FadeInUp(
            key: ValueKey('title_$index'),
            child: Text(
              model.title.tr,
              textAlign: TextAlign.center,
              // ✅ هنا التغيير: الاعتماد على الثيم المركزي
              style: context.textTheme.headlineMedium,
            ),
          ),

          15.verticalSpace,

          FadeInUp(
            key: ValueKey('desc_$index'),
            delay: const Duration(milliseconds: 200),
            child: Text(
              model.description.tr,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
