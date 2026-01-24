import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../data/models/application_model.dart';
import '../controllers/applications_controller.dart';
import 'widgets/application_card_widget.dart';

class ApplicationsView extends GetView<ApplicationsController> {
  const ApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ApplicationsController());

    return Scaffold(
      appBar: AppBar(title: Text('lbl_my_applications'.tr), centerTitle: true),
      body: Column(
        children: [
          // 1. شريط الفلتر المطور
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.h),
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
                    _buildCustomChip(
                      context,
                      'lbl_all'.tr,
                      null,
                      Colors.blue,
                      Icons.grid_view_rounded,
                    ),
                    12.horizontalSpace,
                    _buildCustomChip(
                      context,
                      'status_pending'.tr,
                      AppStatus.pending,
                      Colors.orange,
                      Icons.access_time_rounded,
                    ),
                    12.horizontalSpace,
                    _buildCustomChip(
                      context,
                      'status_accepted'.tr,
                      AppStatus.accepted,
                      Colors.green,
                      Icons.check_circle_outline_rounded,
                    ),
                    12.horizontalSpace,
                    _buildCustomChip(
                      context,
                      'status_rejected'.tr,
                      AppStatus.rejected,
                      Colors.red,
                      Icons.cancel_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. القائمة
          Expanded(
            child: Obx(() {
              final apps = controller.filteredApps;

              if (apps.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_list_off,
                        size: 60.sp,
                        color: Colors.grey.shade300,
                      ),
                      10.verticalSpace,
                      Text(
                        'msg_no_apps'.tr,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  return FadeInUp(
                    key: ValueKey(
                      "${apps[index].id}_${controller.filterStatus.value}",
                    ),
                    duration: const Duration(milliseconds: 300),
                    child: ApplicationCardWidget(application: apps[index]),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomChip(
    BuildContext context,
    String label,
    AppStatus? status,
    Color color,
    IconData icon,
  ) {
    final isSelected = controller.filterStatus.value == status;

    final bgColor = isSelected ? color.withValues(alpha: 0.15) : Colors.transparent;
    final borderColor = isSelected ? color : Colors.grey.shade300;
    final textColor = isSelected ? color : Colors.grey;
    final iconColor = isSelected ? color : Colors.grey;

    return InkWell(
      onTap: () => controller.setFilter(
        status == controller.filterStatus.value ? null : status,
      ),
      // ضغطة ثانية تلغي الفلتر (اختياري)
      borderRadius: BorderRadius.circular(30.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: iconColor),
            8.horizontalSpace,
            Text(
              label,
              style: TextStyle(
                color: textColor,
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
