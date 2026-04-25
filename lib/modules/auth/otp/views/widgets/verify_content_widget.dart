import 'package:ai_job_matcher/modules/auth/otp/controllers/otp_controller.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/common/custom_button.dart';

class VerifyContentWidget extends GetView<OtpController> {
  const VerifyContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'check_email_title'.tr,
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          14.verticalSpace,
          Text(
            'check_email_subtitle'.tr,
            style: context.textTheme.bodyMedium?.copyWith(height: 1.6),
            textAlign: TextAlign.center,
          ),
          18.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,
                  color: Colors.orange.shade700,
                  size: 20.sp,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'check_email_spam_hint'.tr,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          30.verticalSpace,
          CustomButton(
            text: 'open_email_app'.tr,
            onPressed: controller.openEmailApp,
          ),
          14.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.resendLink,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text('resend_link'.tr),
            ),
          ),
          12.verticalSpace,
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.isCheckingVerification.value
                    ? null
                    : controller.manualRefreshStatus,
                icon: controller.isCheckingVerification.value
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text('btn_refresh_status'.tr),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
          ),
          12.verticalSpace,
          Text(
            'resend_email'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          24.verticalSpace,
          TextButton.icon(
            onPressed: controller.skipToLogin,
            icon: const Icon(Icons.logout, color: Colors.grey),
            label: Text(
              'lbl_logout'.tr,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
