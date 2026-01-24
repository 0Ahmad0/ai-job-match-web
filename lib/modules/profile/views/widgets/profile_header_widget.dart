import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../controllers/profile_controller.dart';

class ProfileHeaderWidget extends GetView<ProfileController> {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Column(
        children: [
          // Avatar with Ring
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.theme.primaryColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: controller.userImage.value.isNotEmpty
                  ? NetworkImage(controller.userImage.value)
                  : null,
              child: controller.userImage.value.isEmpty
                  ? Icon(Icons.person, size: 50.sp, color: Colors.grey)
                  : null,
            ),
          ),

          15.verticalSpace,

          // Name
          Text(
            controller.userName.value,
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 22.sp),
          ),

          5.verticalSpace,

          // Job Title
          Text(
            controller.userJob.value,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}