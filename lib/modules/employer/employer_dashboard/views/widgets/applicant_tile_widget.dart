import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_theme.dart';

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
    // Determine score color based on match score
    Color scoreColor = AppTheme.successColor;
    if (matchScore < 80) scoreColor = AppTheme.warningColor;
    if (matchScore < 60) scoreColor = AppTheme.errorColor;

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacing15.h),
      padding: EdgeInsets.all(AppTheme.spacing12.r),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium.r),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.primaryColor.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.person, color: context.theme.primaryColor, size: 30.sp),
          ),
          AppTheme.spacing15.horizontalSpace,

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                AppTheme.spacing4.verticalSpace,
                Text(job, style: context.textTheme.bodySmall),
              ],
            ),
          ),

          // Match Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8.w,
                  vertical: AppTheme.spacing4.h,
                ),
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall.r),
                ),
                child: Text(
                  "$matchScore% ${'lbl_match'.tr}",
                  style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              AppTheme.spacing5.verticalSpace,
              Text(
                time,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
