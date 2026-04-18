import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/shimmer_skeletons.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminJobsView extends GetView<AdminDashboardController> {
  const AdminJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_admin_jobs'.tr), centerTitle: true),
      body: Obx(
        () => Stack(
          children: [
            if (controller.isJobsLoading.value)
              const JobListShimmer()
            else if (controller.jobRequests.isEmpty)
              Center(child: Text('admin_no_pending_jobs'.tr))
            else
              ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: controller.jobRequests.length,
                itemBuilder: (context, index) {
                  final job = controller.jobRequests[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 15.h),
                    child: Padding(
                      padding: EdgeInsets.all(15.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.work, color: Colors.blue),
                              10.horizontalSpace,
                              Expanded(
                                child: Text(
                                  job['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          5.verticalSpace,
                          Text(
                            'lbl_company_salary'.trParams({
                              'company': '${job['company']}',
                              'salary': '${job['salary']}',
                            }),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          10.verticalSpace,
                          Container(
                            padding: EdgeInsets.all(10.r),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              job['desc'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                          15.verticalSpace,
                          Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 10.w,
                            runSpacing: 8.h,
                            children: [
                              OutlinedButton(
                                onPressed: controller.isActionLoading.value
                                    ? null
                                    : () => controller.rejectJob(job['id']),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: Text('btn_reject'.tr),
                              ),
                              ElevatedButton(
                                onPressed: controller.isActionLoading.value
                                    ? null
                                    : () => controller.approveJob(job['id']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  'btn_approve'.tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fade(duration: 320.ms)
                      .slideY(begin: 0.08, end: 0);
                },
              ),
            if (controller.isActionLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.12),
                  child: const Center(
                    child: SizedBox(
                      width: 180,
                      child: ShimmerSkeleton(height: 42, radius: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
