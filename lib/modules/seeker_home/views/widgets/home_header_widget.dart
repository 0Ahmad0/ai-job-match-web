import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/seeker_home_controller.dart'; // تأكد من المسار

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. العثور على الكنترولر للوصول للمتغيرات
    // نستخدم find لأن الكنترولر تم حقنه بالفعل في الصفحة الأب
    final controller = Get.find<SeekerHomeController>();

    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 30.h),
        decoration: BoxDecoration(
          color: context.theme.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // لضمان المحاذاة
              children: [
                // 2. استخدام Expanded لمنع الـ Overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. Obx الآن تراقب متغيراً حقيقياً (userName.value)
                      Obx(() => Text(
                        'home_welcome'.trParams({'name': controller.userName.value}),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1, // لمنع النص من أخذ أكثر من سطر إذا كان طويلاً
                        overflow: TextOverflow.ellipsis,
                      )),

                      5.verticalSpace,

                      Text(
                        'home_subtitle'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                15.horizontalSpace, // مسافة بين النص والصورة

                // صورة البروفايل
                Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Icon(Icons.person, color: Colors.white, size: 30.sp),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}