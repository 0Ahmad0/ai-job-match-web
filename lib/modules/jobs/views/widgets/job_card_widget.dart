import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/models/job_model.dart';

class JobCardWidget extends StatelessWidget {
  const JobCardWidget({
    super.key,
    required this.job,
    required this.isApplied,
    this.onTap,
  });

  final JobModel job;
  final bool isApplied;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var scoreColor = Colors.green;
    if (job.matchScore < 80) scoreColor = Colors.orange;
    if (job.matchScore < 50) scoreColor = Colors.red;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: context.theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 14.w,
              runSpacing: 14.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDBEAFE), Color(0xFFEFF6FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: const Icon(Icons.business_center_outlined, color: Color(0xFF1456F1)),
                ),
                SizedBox(
                  width: 430.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
                      6.verticalSpace,
                      Text(job.company, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${job.matchScore}% ${'lbl_match_score'.tr}',
                    style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 11.sp),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Wrap(
              spacing: 10.w,
              runSpacing: 8.h,
              children: [
                _buildTag(context, job.type, const Color(0xFFE0ECFF), const Color(0xFF1456F1)),
                _buildTag(context, job.location, const Color(0xFFFEEFD6), const Color(0xFFB45309)),
              ],
            ),
            16.verticalSpace,
            Text(job.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.textTheme.bodyMedium),
            16.verticalSpace,
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12.w,
              runSpacing: 10.h,
              children: [
                RichText(
                  text: TextSpan(
                    text: job.salary,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: context.textTheme.bodyLarge?.color),
                    children: [
                      TextSpan(
                        text: ' ${'lbl_salary'.tr}',
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isApplied) ...[
                      Icon(Icons.check_circle, size: 16.sp, color: Colors.green),
                      6.horizontalSpace,
                      Text(
                        'job_applied_badge'.tr,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ] else ...[
                      Text('lbl_apply'.tr, style: TextStyle(color: context.theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                      6.horizontalSpace,
                      Icon(Icons.arrow_forward_rounded, size: 16.sp, color: context.theme.primaryColor),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color bg, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.w700)),
    );
  }
}
