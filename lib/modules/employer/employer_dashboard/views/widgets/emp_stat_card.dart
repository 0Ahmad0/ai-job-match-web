import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/common/app_ui.dart';
import '../../../../../core/theme/app_theme.dart';

class EmpStatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const EmpStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemedCard(
      elevation: AppElevation.small,
      padding: EdgeInsets.all(AppTheme.spacing15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              width: 80.w,
              height: 80.w,
              padding: EdgeInsets.all(AppTheme.spacing8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 36.sp),
            ),
          ),
          AppTheme.spacing12.verticalSpace,
          Flexible(
            child: Text(
              count,
              style: context.textTheme.displaySmall?.copyWith(
                color: color,
              ),
            ),
          ),
          AppTheme.spacing8.verticalSpace,
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}