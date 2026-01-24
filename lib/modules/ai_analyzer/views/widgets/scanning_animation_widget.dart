import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/ai_analyzer_controller.dart';

class ScanningAnimationWidget extends GetView<AiAnalyzerController> {
  const ScanningAnimationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الرادار
          Stack(
            alignment: Alignment.center,
            children: [
              Pulse(
                infinite: true,
                duration: const Duration(seconds: 2),
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.primaryColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Pulse(
                infinite: true,
                delay: const Duration(milliseconds: 500),
                duration: const Duration(seconds: 2),
                child: Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              Icon(Icons.auto_awesome, size: 60.sp, color: context.theme.primaryColor),
            ],
          ),

          50.verticalSpace,

          // النص المتغير
          Obx(() => FadeIn(
            key: ValueKey(controller.scanningStatus.value), // مفتاح لتفعيل الانميشن عند تغيير النص
            child: Text(
              controller.scanningStatus.value,
              style: context.textTheme.headlineSmall?.copyWith(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          )),

          20.verticalSpace,
          SizedBox(
            width: 200.w,
            child: LinearProgressIndicator(
              color: context.theme.primaryColor,
              backgroundColor: context.theme.primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}