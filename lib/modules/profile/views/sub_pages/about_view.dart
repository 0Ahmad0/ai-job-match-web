import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('about_title'.tr), centerTitle: true),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZoomIn(
                child: Container(
                  height: 120.h,
                  width: 120.h,
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.auto_awesome, size: 60.sp, color: context.theme.primaryColor),
                ),
              ),
              20.verticalSpace,
              Text(
                'app_name'.tr,
                style: context.textTheme.headlineMedium,
              ),
              10.verticalSpace,
              Text(
                'version'.tr,
                style: const TextStyle(color: Colors.grey),
              ),
              40.verticalSpace,
              Text(
                'about_desc'.tr,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),

              const Spacer(),

              Text('app_copyright'.tr, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
