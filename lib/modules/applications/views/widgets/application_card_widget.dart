import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/models/application_model.dart';
import '../../../../routes/app_routes.dart';

class ApplicationCardWidget extends StatelessWidget {
  const ApplicationCardWidget({super.key, required this.application});

  final ApplicationModel application;

  @override
  Widget build(BuildContext context) {
    final statusMeta = _statusMeta(application.status);
    final isInterview = application.status == AppStatus.interviewScheduled;

    return InkWell(
      onTap: () => Get.toNamed(Routes.TRACK_APPLICATION, arguments: application),
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: context.theme.dividerColor),
        ),
        child: Column(
          children: [
            Wrap(
              spacing: 14.w,
              runSpacing: 12.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: const Icon(Icons.business_center_outlined, color: Colors.grey),
                ),
                SizedBox(
                  width: 450.w,
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: isInterview
                        ? Colors.indigo.withValues(alpha: 0.12)
                        : statusMeta.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.r),
                    border: isInterview
                        ? Border.all(color: Colors.indigo.withValues(alpha: 0.35))
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusMeta.icon, size: 15.sp, color: statusMeta.color),
                      6.horizontalSpace,
                      Text(
                        statusMeta.label,
                        style: TextStyle(color: statusMeta.color, fontWeight: FontWeight.bold, fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
                if (application.status == AppStatus.rejected &&
                    (application.rejectionReason ?? '').trim().isNotEmpty)
                  InkWell(
                    onTap: () => _showRejectionReason(context),
                    borderRadius: BorderRadius.circular(999.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                      child: Icon(Icons.info_outline, size: 18.sp, color: Colors.red.shade700),
                    ),
                  ),
              ],
            ),
            16.verticalSpace,
            Divider(color: context.theme.dividerColor),
            12.verticalSpace,
            Wrap(
              spacing: 14.w,
              runSpacing: 10.h,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(
                  "${'lbl_applied_on'.tr}: ${application.appliedDate}",
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
                if (application.matchScore != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      'lbl_ai_match'.trParams({'score': application.matchScore.toString()}),
                      style: TextStyle(
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'lbl_track'.tr,
                      style: TextStyle(
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    5.horizontalSpace,
                    Icon(Icons.arrow_forward, size: 14.sp, color: context.theme.primaryColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StatusMeta _statusMeta(AppStatus status) {
    switch (status) {
      case AppStatus.accepted:
        return _StatusMeta('status_accepted'.tr, Colors.green, Icons.check_circle_outline);
      case AppStatus.interviewScheduled:
        return _StatusMeta('status_interview'.tr, Colors.indigo, Icons.event_available_outlined);
      case AppStatus.rejected:
        return _StatusMeta('status_rejected'.tr, Colors.red, Icons.cancel_outlined);
      case AppStatus.underReview:
        return _StatusMeta('status_pending'.tr, Colors.orange, Icons.access_time);
      case AppStatus.applied:
        return _StatusMeta('status_applied'.tr, Colors.grey, Icons.send_rounded);
    }
  }

  void _showRejectionReason(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('lbl_rejection_reason'.tr),
        content: Text(application.rejectionReason ?? ''),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('btn_cancel'.tr),
          ),
        ],
      ),
    );
  }
}

class _StatusMeta {
  _StatusMeta(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}
