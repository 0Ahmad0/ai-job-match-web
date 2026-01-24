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
        children: [
          Text(
            'check_email_title'.tr,
            style: context.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          15.verticalSpace,
          Text(
            'check_email_subtitle'.tr,
            style: context.textTheme.bodyMedium?.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),

          40.verticalSpace,

          // Open Email App Button
          CustomButton(
            text: 'open_email_app'.tr,
            onPressed: controller.openEmailApp,
          ),

          20.verticalSpace,

          // Skip / Back to Login
          TextButton(
            onPressed: controller.skipToLogin,
            child: Text(
              'skip_sign_in'.tr,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),

          40.verticalSpace,

          // Resend Link Footer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Text(
                  'resend_email'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                TextButton(
                  onPressed: controller.resendLink,
                  child: Text(
                    'resend_link'.tr,
                    style: TextStyle(
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}