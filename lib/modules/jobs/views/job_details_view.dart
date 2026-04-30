import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/custom_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/job_model.dart';
import '../controllers/jobs_controller.dart';
import 'widgets/apply_bottom_sheet.dart';

class JobDetailsView extends StatelessWidget {
  final JobModel job;

  const JobDetailsView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final jobsController = Get.find<JobsController>();

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      bottomNavigationBar: Obx(() {
        final isApplied = jobsController.hasApplied(job.id);
        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightText.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: isApplied
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: Get.back,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: Text('btn_back'.tr),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: SizedBox(
                          height: 52.h,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'job_applied_cta_disabled'.tr,
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : CustomButton(
                    text: 'lbl_apply_now'.tr,
                    onPressed: () {
                      Get.bottomSheet(
                        ApplyBottomSheet(job: job),
                        isScrollControlled: true,
                      );
                    },
                  ),
          ),
        );
      }),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: context.textTheme.bodyLarge?.color,
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.bookmark_border,
                  color: context.textTheme.bodyLarge?.color,
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  40.verticalSpace,
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightBorder,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.business,
                      size: 40.sp,
                      color: AppTheme.lightMuted,
                    ),
                  ),
                  15.verticalSpace,
                  Text(
                    job.company,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.lightMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      job.title,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 22.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  10.verticalSpace,
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'lbl_ai_match'.trParams({
                          'score': job.matchScore.toString(),
                        }),
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.work_outline,
                        job.type,
                        'lbl_job_type'.tr,
                      ),
                      _buildInfoChip(
                        context,
                        Icons.history,
                        job.experienceYears,
                        'lbl_exp_years'.tr,
                      ),
                      _buildInfoChip(
                        context,
                        Icons.bar_chart,
                        job.level,
                        'lbl_level'.tr,
                      ),
                      _buildInfoChip(
                        context,
                        Icons.attach_money,
                        job.salary,
                        'lbl_salary'.tr,
                      ),
                    ],
                  ),
                  30.verticalSpace,
                  Divider(color: Colors.grey.withValues(alpha: 0.2)),
                  20.verticalSpace,
                  Text(
                    'lbl_about_role'.tr,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    job.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: AppTheme.lightMuted,
                    ),
                  ),
                  30.verticalSpace,
                  Text(
                    'lbl_key_req'.tr,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  15.verticalSpace,
                  ...job.requirements.map(
                    (req) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: context.theme.primaryColor,
                            size: 20.sp,
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: Text(
                              req,
                              style: context.textTheme.bodyMedium?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  50.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.lightBorder),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20.sp, color: context.theme.primaryColor),
          8.verticalSpace,
          Text(
            value.replaceAll('lbl_salary'.tr, '').trim(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          Text(
            label,
            style: TextStyle(color: AppTheme.lightMuted, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
