import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDestructive;

  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDestructive ? AppTheme.errorColor : context.theme.primaryColor;

    return AppThemedListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(AppTheme.spacing8.r),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall.r),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.errorColor : null,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: context.theme.dividerColor,
      ),
    );
  }
}