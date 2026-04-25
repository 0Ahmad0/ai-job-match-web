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
          () {
            final userName = controller.userName.value;
            final userJob = controller.userJob.value;
            final userEmail = controller.userEmail.value;
            final userBio = controller.userBio.value;
            final userImage = controller.userImage.value;

            return LayoutBuilder(
            builder: (context, constraints) {
              final details = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  AppTheme.spacing6.verticalSpace,
                  Text(
                    userJob,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  AppTheme.spacing6.verticalSpace,
                  Text(
                    userEmail,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                  if (userBio.isNotEmpty) ...[
                    AppTheme.spacing12.verticalSpace,
                    Text(
                      userBio,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ],
              );

              if (constraints.maxWidth < 560.w) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppUserAvatar(
                      name: userName,
                      imageUrl: userImage,
                      radius: 38,
                    ),
                    AppTheme.spacing18.verticalSpace,
                    details,
                  ],
                );
              }

              return Row(
                children: [
                  AppUserAvatar(
                    name: userName,
                    imageUrl: userImage,
                    radius: 38,
                  ),
                  AppTheme.spacing18.horizontalSpace,
                  Expanded(child: details),
                ],
              );
            },
          );
          },
        ),
      ),
    );
  }
}
