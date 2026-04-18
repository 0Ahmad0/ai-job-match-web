import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/app_ui.dart';
import '../../../core/common/shimmer_skeletons.dart';
import '../../../data/models/application_model.dart';
import '../controllers/applications_controller.dart';
import 'widgets/application_card_widget.dart';

class ApplicationsView extends GetView<ApplicationsController> {
  const ApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_my_applications'.tr), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => Row(
                  children: [
                    _buildChip(context, 'lbl_all'.tr, null, Colors.blue, Icons.grid_view_rounded),
                    10.horizontalSpace,
                    _buildChip(context, 'status_applied'.tr, AppStatus.applied, Colors.grey, Icons.send_rounded),
                    10.horizontalSpace,
                    _buildChip(context, 'status_under_review'.tr, AppStatus.underReview, Colors.orange, Icons.visibility_rounded),
                    10.horizontalSpace,
                    _buildChip(context, 'status_interview_scheduled'.tr, AppStatus.interviewScheduled, Colors.indigo, Icons.event_available_outlined),
                    10.horizontalSpace,
                    _buildChip(context, 'status_accepted'.tr, AppStatus.accepted, Colors.green, Icons.check_circle_outline_rounded),
                    10.horizontalSpace,
                    _buildChip(context, 'status_rejected'.tr, AppStatus.rejected, Colors.red, Icons.cancel_outlined),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: ApplicationListShimmer(),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return AppStateCard(
                  icon: Icons.error_outline,
                  title: 'err_title'.tr,
                  message: controller.errorMessage.value,
                  action: SizedBox(
                    width: 220.w,
                    child: ElevatedButton(
                      onPressed: controller.loadApplications,
                      child: Text('btn_retry'.tr),
                    ),
                  ),
                );
              }

              final apps = controller.filteredApps;
              if (apps.isEmpty) {
                return AppStateCard(
                  icon: Icons.assignment_outlined,
                  title: 'applications_empty_title'.tr,
                  message: 'msg_no_apps'.tr,
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  return ApplicationCardWidget(application: apps[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, AppStatus? status, Color color, IconData icon) {
    final isSelected = controller.filterStatus.value == status;
    return InkWell(
      onTap: () => controller.setFilter(status == controller.filterStatus.value ? null : status),
      borderRadius: BorderRadius.circular(30.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: 1.3),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: isSelected ? color : Colors.grey),
            8.horizontalSpace,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
