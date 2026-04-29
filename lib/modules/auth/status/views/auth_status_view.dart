import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/custom_button.dart';
import '../../auth_controller.dart';

class AuthStatusView extends StatelessWidget {
  const AuthStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final args = (Get.arguments as Map<String, dynamic>?) ?? {};
    final titleKey = (args['titleKey'] as String?) ?? 'status_pending_title';
    final messageKey =
        (args['messageKey'] as String?) ?? 'status_pending_message';
    final showRefresh = (args['showRefresh'] as bool?) ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 620.w),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96.w,
                        height: 96.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              context.theme.primaryColor,
                              context.theme.primaryColor.withValues(alpha: 0.75),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.hourglass_top_rounded,
                          size: 46.sp,
                          color: Colors.white,
                        ),
                      ),
                      24.verticalSpace,
                      Text(
                        titleKey.tr,
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      14.verticalSpace,
                      Text(
                        messageKey.tr,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                          color: context.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.85),
                        ),
                      ),
                      22.verticalSpace,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20.sp,
                              color: context.theme.primaryColor,
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Text(
                                'status_keep_session_hint'.tr,
                                style: context.textTheme.bodySmall?.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      28.verticalSpace,
                      if (showRefresh) ...[
                        CustomButton(
                          text: 'btn_refresh_status'.tr,
                          onPressed: () async {
                            await authController.refreshCurrentUser();
                            final destination =
                                await authController.resolveSessionDestination();
                            if (destination == null) {
                              return;
                            }
                            Get.offAllNamed(
                              destination['route'] as String,
                              arguments: destination['arguments'],
                            );
                          },
                        ),
                        14.verticalSpace,
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await authController.logout();
                            Get.offAllNamed('/auth/login');
                          },
                          icon: const Icon(Icons.logout),
                          label: Text('lbl_logout'.tr),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fade(duration: 320.ms)
                    .slideY(begin: 0.06, end: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
