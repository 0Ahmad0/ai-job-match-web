import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/profile_controller.dart';

class ProfileStatsWidget extends GetView<ProfileController> {
  const ProfileStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 120),
      child: Obx(
        () => AppThemedCard(
          elevation: AppElevation.small,
          padding: EdgeInsets.symmetric(
            vertical: AppTheme.spacing22.h,
            horizontal: AppTheme.spacing16.w,
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: AppTheme.spacing14.w,
            runSpacing: AppTheme.spacing14.h,
            children: _itemsForRole(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _itemsForRole(BuildContext context) {
    if (controller.userRole.value == 'company') {
      return [
        _buildStatItem(context, controller.statApplied.value.toString(), 'profile_stat_active_jobs'.tr, Icons.work_outline),
        _buildStatItem(context, controller.statReviewed.value.toString(), 'profile_stat_applicants'.tr, Icons.group_outlined),
        _buildStatItem(context, controller.statInterviews.value.toString(), 'stat_interviews_scheduled'.tr, Icons.calendar_month_outlined),
      ];
    }

    if (controller.userRole.value == 'admin') {
      return [
        _buildStatItem(context, controller.statApplied.value.toString(), 'profile_stat_total_users'.tr, Icons.groups_2_outlined),
        _buildStatItem(context, controller.statReviewed.value.toString(), 'profile_stat_pending_approvals'.tr, Icons.verified_user_outlined),
        _buildStatItem(context, controller.statInterviews.value.toString(), 'profile_stat_pending_jobs'.tr, Icons.fact_check_outlined),
      ];
    }

    return [
      _buildStatItem(context, controller.statApplied.value.toString(), 'stat_applied'.tr, Icons.send_outlined),
      _buildStatItem(context, controller.statReviewed.value.toString(), 'profile_stat_under_review'.tr, Icons.visibility_outlined),
      _buildStatItem(context, controller.statInterviews.value.toString(), 'stat_interviews'.tr, Icons.forum_outlined),
    ];
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return SizedBox(
      width: 120.w,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: context.theme.primaryColor),
          ),
          AppTheme.spacing10.verticalSpace,
          Text(
            value,
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
          AppTheme.spacing6.verticalSpace,
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
