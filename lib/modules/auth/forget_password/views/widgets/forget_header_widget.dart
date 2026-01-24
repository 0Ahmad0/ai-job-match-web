import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class ForgetHeaderWidget extends StatelessWidget {
  const ForgetHeaderWidget({super.key});

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
              color: Colors.orange.withValues(alpha: 0.1), // لون مختلف للتمييز
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(Icons.lock_reset, size: 40.sp, color: Colors.orange),
          ),
          20.verticalSpace,
          Text(
            'reset_pass_title'.tr,
            style: context.textTheme.headlineLarge,
          ),
          10.verticalSpace,
          Text(
            'reset_pass_subtitle'.tr,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}