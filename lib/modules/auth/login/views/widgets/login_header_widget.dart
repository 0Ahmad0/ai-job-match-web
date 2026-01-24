import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(Icons.auto_awesome, size: 40.sp, color: context.theme.primaryColor),
          ),
          20.verticalSpace,
          Text(
            'login_title'.tr,
            style: context.textTheme.headlineLarge,
          ),
          10.verticalSpace,
          Text(
            'login_subtitle'.tr,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}