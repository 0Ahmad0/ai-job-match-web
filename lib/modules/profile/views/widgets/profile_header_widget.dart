import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/profile_controller.dart';

class ProfileHeaderWidget extends GetView<ProfileController> {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppTheme.spacing24.r),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusXXL.r),
          boxShadow: AppTheme.shadowLarge,
        ),
        child: Obx(
          () => Wrap(
            spacing: AppTheme.spacing18.w,
            runSpacing: AppTheme.spacing18.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppUserAvatar(
                name: controller.userName.value,
                imageUrl: controller.userImage.value,
                radius: 38,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName.value,
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    AppTheme.spacing6.verticalSpace,
                    Text(
                      controller.userJob.value,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                    AppTheme.spacing6.verticalSpace,
                    Text(
                      controller.userEmail.value,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                    if (controller.userBio.value.isNotEmpty) ...[
                      AppTheme.spacing12.verticalSpace,
                      Text(
                        controller.userBio.value,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
