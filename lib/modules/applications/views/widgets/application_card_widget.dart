import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/models/application_model.dart';
import '../track_application_view.dart';

class ApplicationCardWidget extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCardWidget({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان والنص حسب الحالة
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (application.status) {
      case AppStatus.accepted:
        statusColor = Colors.green;
        statusText = 'status_accepted'.tr;
        statusIcon = Icons.check_circle_outline;
        break;
      case AppStatus.rejected:
        statusColor = Colors.red;
        statusText = 'status_rejected'.tr;
        statusIcon = Icons.cancel_outlined;
        break;
      case AppStatus.pending:
      default:
        statusColor = Colors.orange;
        statusText = 'status_pending'.tr;
        statusIcon = Icons.access_time;
        break;
    }

    return InkWell(
      onTap: (){
        Get.to(() => TrackApplicationView(application: application));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Company Logo Placeholder
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(Icons.business, color: Colors.grey),
                ),
                15.horizontalSpace,

                // Job Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.jobTitle,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      5.verticalSpace,
                      Text(
                        application.company,
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 14.sp, color: statusColor),
                      5.horizontalSpace,
                      Text(
                        statusText,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            15.verticalSpace,
            Divider(color: Colors.grey.withValues(alpha: 0.1)),
            10.verticalSpace,

            // Date & Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${'lbl_applied_on'.tr}: ${application.appliedDate}",
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),

                // Track Button (Optional visual cue)
                Row(
                  children: [
                    Text(
                      'lbl_track'.tr,
                      style: TextStyle(
                          color: context.theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp
                      ),
                    ),
                    5.horizontalSpace,
                    Icon(Icons.arrow_forward, size: 14.sp, color: context.theme.primaryColor),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}