import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ApplicantTileWidget extends StatelessWidget {
  final String name;
  final String job;
  final int matchScore;
  final String time;

  const ApplicantTileWidget({
    super.key,
    required this.name,
    required this.job,
    required this.matchScore,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    // لون النسبة
    Color scoreColor = Colors.green;
    if (matchScore < 80) scoreColor = Colors.orange;
    if (matchScore < 60) scoreColor = Colors.red;

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.person, color: Colors.grey, size: 30.sp),
          ),
          15.horizontalSpace,

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                4.verticalSpace,
                Text(job, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ],
            ),
          ),

          // Match Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "$matchScore% Match",
                  style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 10.sp),
                ),
              ),
              5.verticalSpace,
              Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 10.sp)),
            ],
          )
        ],
      ),
    );
  }
}