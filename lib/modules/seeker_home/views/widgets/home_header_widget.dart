import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../controllers/seeker_home_controller.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SeekerHomeController>();

    return FadeInDown(
      duration: const Duration(milliseconds: 650),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 28.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1456F1), Color(0xFF0E2F79)],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(34.r),
            bottomRight: Radius.circular(34.r),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x221456F1),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.isHeaderLoading.value
                            ? '...'
                            : 'home_welcome'.trParams({'name': controller.userName.value}),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      6.verticalSpace,
                      Text(
                        'home_subtitle'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.84),
                        ),
                      ),
                    ],
                  ),
                ),
                16.horizontalSpace,
                Column(
                  children: [
                    AppUserAvatar(
                      name: controller.userName.value,
                      imageUrl: controller.userImage.value,
                      radius: 24,
                      onTap: controller.openProfile,
                    ),
                    8.verticalSpace,
                    Text(
                      'nav_profile'.tr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
