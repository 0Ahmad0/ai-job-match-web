import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/common/app_ui.dart';
import '../../../../../core/theme/app_theme.dart';

class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemedCard(
      elevation: AppElevation.small,
      padding: EdgeInsets.all(AppTheme.spacing16.r),
      border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.sp),
              Text(
                value,
                style: context.textTheme.headlineSmall?.copyWith(color: color),
              ),
            ],
          ),
          AppTheme.spacing10.verticalSpace,
          Text(
            title,
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
