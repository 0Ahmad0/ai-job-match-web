import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/profile_controller.dart';

class ProfileStatsWidget extends GetView<ProfileController> {
  const ProfileStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(context, controller.statApplied.value.toString(), 'stat_applied'.tr),
            _buildDivider(),
            _buildStatItem(context, controller.statReviewed.value.toString(), 'stat_reviewed'.tr),
            _buildDivider(),
            _buildStatItem(context, controller.statInterviews.value.toString(), 'stat_interviews'.tr),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: context.theme.primaryColor,
          ),
        ),
        5.verticalSpace,
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30.h,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }
}