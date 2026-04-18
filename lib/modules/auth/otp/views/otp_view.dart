import 'package:ai_job_matcher/modules/auth/otp/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widgets/verify_content_widget.dart';
import 'widgets/verify_illustration_widget.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('app_name'.tr),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.theme.primaryColor.withValues(alpha: 0.10),
                    context.theme.scaffoldBackgroundColor,
                    context.theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 680.w),
                  child: Container(
                    padding: EdgeInsets.all(28.r),
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(
                        color: context.theme.primaryColor.withValues(alpha: 0.14),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 560;
                        if (isWide) {
                          return Row(
                            children: [
                              const Expanded(child: VerifyIllustrationWidget()),
                              24.horizontalSpace,
                              const Expanded(child: VerifyContentWidget()),
                            ],
                          );
                        }

                        return const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerifyIllustrationWidget(),
                            VerifyContentWidget(),
                          ],
                        );
                      },
                    ),
                  )
                      .animate()
                      .fade(duration: 320.ms)
                      .slideY(begin: 0.06, end: 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
