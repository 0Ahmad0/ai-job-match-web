import 'package:ai_job_matcher/modules/auth/otp/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widgets/verify_illustration_widget.dart';
import 'widgets/verify_content_widget.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VerifyIllustrationWidget(),
              40.verticalSpace,
              const VerifyContentWidget(),
            ],
          ),
        ),
      ),
    );
  }
}