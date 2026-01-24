import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/common/custom_button.dart';
import '../../../data/models/job_model.dart';
import 'widgets/apply_bottom_sheet.dart';


class JobDetailsView extends StatelessWidget {
  final JobModel job;

  const JobDetailsView({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      // زر التقديم الثابت في الأسفل
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: CustomButton(
          text: 'lbl_apply_now'.tr,
          onPressed: () {
            Get.bottomSheet(
              ApplyBottomSheet(job: job),
              isScrollControlled: true,
            );
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. App Bar with Company Info
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: context.textTheme.bodyLarge?.color),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.bookmark_border, color: context.textTheme.bodyLarge?.color),
                onPressed: () {},
              )
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
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(Icons.business, size: 40.sp, color: Colors.grey),
                  ),
                  15.verticalSpace,
                  Text(
                    job.company,
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // 2. Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Match Score
                  Center(
                    child: Text(
                      job.title,
                      style: context.textTheme.headlineMedium?.copyWith(fontSize: 22.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  10.verticalSpace,
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "AI Match: ${job.matchScore}%",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                    ),
                  ),

                  30.verticalSpace,

                  // 3. Quick Stats Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(context, Icons.work_outline, job.type, 'lbl_job_type'.tr),
                      _buildInfoChip(context, Icons.history, job.experienceYears, 'lbl_exp_years'.tr),
                      _buildInfoChip(context, Icons.bar_chart, job.level, 'lbl_level'.tr),
                      _buildInfoChip(context, Icons.attach_money, job.salary, 'lbl_salary'.tr),
                    ],
                  ),

                  30.verticalSpace,
                  Divider(color: Colors.grey.withValues(alpha: 0.2)),
                  20.verticalSpace,

                  // 4. Description
                  Text('lbl_about_role'.tr, style: context.textTheme.headlineSmall?.copyWith(fontSize: 18.sp)),
                  10.verticalSpace,
                  Text(
                    job.description,
                    style: context.textTheme.bodyMedium?.copyWith(height: 1.6, color: Colors.grey),
                  ),

                  30.verticalSpace,

                  // 5. Requirements
                  Text('lbl_key_req'.tr, style: context.textTheme.headlineSmall?.copyWith(fontSize: 18.sp)),
                  15.verticalSpace,
                  ...job.requirements.map((req) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: context.theme.primaryColor, size: 20.sp),
                        10.horizontalSpace,
                        Expanded(
                          child: Text(
                            req,
                            style: context.textTheme.bodyMedium?.copyWith(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )),

                  50.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String value, String label) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20.sp, color: context.theme.primaryColor),
          8.verticalSpace,
          Text(
            value.replaceAll('/Month', ''), // تنظيف النص اذا كان طويلاً
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 10.sp)),
        ],
      ),
    );
  }
}