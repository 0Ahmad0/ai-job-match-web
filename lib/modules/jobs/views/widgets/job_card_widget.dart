import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/models/job_model.dart';
class JobCardWidget extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onTap;

  const JobCardWidget({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    // تحديد لون نسبة التطابق
    Color scoreColor = Colors.green;
    if (job.matchScore < 80) scoreColor = Colors.orange;
    if (job.matchScore < 50) scoreColor = Colors.red;

    return GestureDetector(
      onTap: onTap,
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
            // Row 1: Logo + Title + Bookmark
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(Icons.business, color: Colors.grey), // Placeholder Logo
                ),
                15.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      5.verticalSpace,
                      Text(
                        job.company,
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.bookmark_border, color: Colors.grey, size: 22.sp),
              ],
            ),

            15.verticalSpace,

            // Row 2: Tags (Type, Location)
            Row(
              children: [
                _buildTag(context, job.type, Colors.blue.withValues(alpha: 0.1), Colors.blue),
                10.horizontalSpace,
                _buildTag(context, job.location, Colors.purple.withValues(alpha: 0.1), Colors.purple),
              ],
            ),

            15.verticalSpace,
            Divider(color: Colors.grey.withValues(alpha: 0.1)),
            5.verticalSpace,

            // Row 3: Salary + Match Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: job.salary,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: context.textTheme.bodyLarge?.color),
                    children: [
                      TextSpan(text: 'lbl_salary'.tr, style: TextStyle(color: Colors.grey, fontSize: 10.sp, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),

                // Match Score Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 12.sp, color: scoreColor),
                      5.horizontalSpace,
                      Text(
                        "${job.matchScore}% ${'lbl_match_score'.tr}",
                        style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color bg, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}