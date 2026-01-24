import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/ai_analyzer_controller.dart';

class UploadBoxWidget extends GetView<AiAnalyzerController> {
  const UploadBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: controller.pickFile,
            child: Container(
              width: double.infinity,
              height: 250.h,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.theme.primaryColor.withValues(alpha: 0.5), width: 2), // يمكن استبداله بـ DottedBorder إذا أضفت المكتبة
                boxShadow: [
                  BoxShadow(
                    color: context.theme.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Icon(
                    controller.fileName.isEmpty ? Icons.cloud_upload_outlined : Icons.description,
                    size: 60.sp,
                    color: context.theme.primaryColor,
                  )),
                  20.verticalSpace,
                  Obx(() => Text(
                    controller.fileName.isEmpty ? 'upload_title'.tr : controller.fileName.value,
                    style: context.textTheme.headlineSmall?.copyWith(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                  )),
                  10.verticalSpace,
                  if(controller.fileName.isEmpty)
                    Text(
                      'upload_desc'.tr,
                      style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
          40.verticalSpace,
          Obx(() {
            if (controller.fileName.isNotEmpty) {
              return SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.startAnalysis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text('btn_analyze'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}