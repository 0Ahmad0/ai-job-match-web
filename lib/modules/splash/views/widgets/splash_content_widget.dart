import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashContentWidget extends StatelessWidget {
  const SplashContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم ألوان الثيم الحالي
    final primary = context.theme.primaryColor;
    final isDark = context.isDarkMode;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. Logo Icon with Pulse Animation
        ZoomIn(
          duration: const Duration(milliseconds: 1500),
          child: Container(
            height: 120.h,
            width: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome, // أيقونة تعبر عن الـ AI
              size: 60.sp,
              color: primary,
            ),
          ),
        ),

        30.verticalSpace,

        // 2. App Name with Fade Animation
        FadeInUp(
          duration: const Duration(milliseconds: 1200),
          delay: const Duration(milliseconds: 500),
          child: Text(
            'app_name'.tr,
            style: GoogleFonts.poppins(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: 1.5,
            ),
          ),
        ),

        10.verticalSpace,

        // 3. Subtitle / Loading Text
        FadeInUp(
          duration: const Duration(milliseconds: 1200),
          delay: const Duration(milliseconds: 1000),
          child: Text(
            'loading'.tr,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
        ),

        50.verticalSpace,

        // 4. Custom Linear Progress Indicator
        FadeIn(
          delay: const Duration(milliseconds: 1500),
          child: SizedBox(
            width: 200.w,
            child: LinearProgressIndicator(
              backgroundColor: primary.withValues(alpha: .2),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
              minHeight: 4.h,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
