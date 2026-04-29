import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/shimmer_skeletons.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/candidates_controller.dart';
import 'widgets/candidate_card_widget.dart';

class CandidatesView extends GetView<CandidatesController> {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lbl_candidates_title'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'lbl_post_job'.tr,
            onPressed: () => Get.toNamed(Routes.COMPANY_POST_JOB),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      'lbl_candidate_job_header'.trParams({
                        'job': controller.activeJobTitle.value.isEmpty
                            ? 'unknown_job'.tr
                            : controller.activeJobTitle.value,
                      }),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                8.horizontalSpace,
                Obx(
                  () => Text(
                    'lbl_applicants_count'.trParams({
                      'count': controller.filteredCandidates.length.toString(),
                    }),
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ).animate().fade(duration: 300.ms).slideY(begin: 0.06, end: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(context, 'lbl_all'.tr, 'all'),
                    8.horizontalSpace,
                    _buildFilterChip(context, 'status_applied'.tr, 'applied'),
                    8.horizontalSpace,
                    _buildFilterChip(context, 'status_under_review'.tr, 'under_review'),
                    8.horizontalSpace,
                    _buildFilterChip(context, 'status_accepted'.tr, 'accepted'),
                    8.horizontalSpace,
                    _buildFilterChip(context, 'status_interview_scheduled'.tr, 'interview_scheduled'),
                    8.horizontalSpace,
                    _buildFilterChip(context, 'status_rejected'.tr, 'rejected'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const CandidateListShimmer();
              }
              final items = controller.filteredCandidates;
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'msg_no_applicants'.tr,
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return CandidateCardWidget(candidate: items[index])
                      .animate()
                      .fade(duration: 300.ms)
                      .slideY(begin: 0.08, end: 0, delay: (index * 40).ms);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String title, String value) {
    final selected = controller.selectedStatusFilter.value == value;
    return InkWell(
      onTap: () => controller.setStatusFilter(value),
      borderRadius: BorderRadius.circular(999.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? context.theme.primaryColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? context.theme.primaryColor : Colors.grey.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: selected ? context.theme.primaryColor : Colors.grey,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
