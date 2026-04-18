import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/common/shimmer_skeletons.dart';
import '../../../routes/app_routes.dart';
import '../../jobs/controllers/jobs_controller.dart';
import '../../jobs/views/widgets/job_card_widget.dart';
import '../controllers/seeker_home_controller.dart';
import 'widgets/action_card_widget.dart';
import 'widgets/home_header_widget.dart';

class SeekerHomeView extends GetView<SeekerHomeController> {
  const SeekerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsController = Get.find<JobsController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Column(
            children: [
              const HomeHeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Obx(
                    () {
                  // While jobs data is loading, show skeleton/loading state
                  if (jobsController.isLoading.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'home_start_journey'.tr,
                          style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp),
                        ).animate().fade().slideY(begin: 0.06, end: 0),
                        20.verticalSpace,
                        // Show action cards but disable them during loading
                        ActionCardWidget(
                          title: 'card_create_title'.tr,
                          description: 'card_create_desc'.tr,
                          icon: FontAwesomeIcons.penNib,
                          color: Colors.teal,
                          onTap: controller.onCreateCvTap,
                        ).animate().fade().slideY(begin: 0.08, end: 0),
                        20.verticalSpace,
                        ActionCardWidget(
                          title: 'card_upload_title'.tr,
                          description: 'card_upload_desc'.tr,
                          icon: FontAwesomeIcons.filePdf,
                          color: Colors.orange,
                          onTap: controller.onUploadCvTap,
                        ).animate().fade().slideY(begin: 0.08, end: 0),
                        30.verticalSpace,
                        // Show loading shimmer for jobs section
                        Text(
                          'recommended_jobs'.tr,
                          style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp),
                        ),
                        15.verticalSpace,
                        const JobListShimmer(itemCount: 3),
                      ],
                    );
                  }

                  // Jobs data is loaded, show actual content
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'home_start_journey'.tr,
                        style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp),
                      ).animate().fade().slideY(begin: 0.06, end: 0),
                      20.verticalSpace,
                      ActionCardWidget(
                        title: 'card_create_title'.tr,
                        description: 'card_create_desc'.tr,
                        icon: FontAwesomeIcons.penNib,
                        color: Colors.teal,
                        onTap: controller.onCreateCvTap,
                      ).animate().fade().slideY(begin: 0.08, end: 0),
                      20.verticalSpace,
                      ActionCardWidget(
                        title: 'card_upload_title'.tr,
                        description: 'card_upload_desc'.tr,
                        icon: FontAwesomeIcons.filePdf,
                        color: Colors.orange,
                        onTap: controller.onUploadCvTap,
                      ).animate().fade().slideY(begin: 0.08, end: 0),
                      20.verticalSpace,
                      if (jobsController.isCvUploaded.value) ...[
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 8.h,
                          spacing: 10.w,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'recommended_jobs'.tr,
                              style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed(Routes.JOBS),
                              child: Text(
                                'view_all'.tr,
                                style: TextStyle(
                                  color: context.theme.primaryColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fade().slideY(begin: 0.05, end: 0),
                        15.verticalSpace,
                        if (jobsController.allJobs.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(24.r),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.search_off, size: 48.sp, color: Colors.grey.shade400),
                                12.verticalSpace,
                                Text(
                                  'msg_no_jobs_available'.tr,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: jobsController.allJobs.take(3).map((job) {
                              return JobCardWidget(
                                job: job,
                                isApplied: jobsController.hasApplied(job.id),
                                onTap: () {
                                  Get.toNamed(Routes.JOB_DETAILS, arguments: job);
                                },
                              )
                                  .animate()
                                  .fade(duration: 280.ms)
                                  .slideY(begin: 0.06, end: 0);
                            }).toList(),
                          ),
                      ],
                    ],
                  );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
