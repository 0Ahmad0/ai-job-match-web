import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/shimmer_skeletons.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminUsersView extends GetView<AdminDashboardController> {
  const AdminUsersView({super.key});

  String _localizedUserType(String type) {
    if (type == 'Employer') {
      return 'user_type_employer'.tr;
    }
    if (type == 'Seeker') {
      return 'user_type_seeker'.tr;
    }
    return type;
  }

  String _localizedStatus(String status) {
    if (status == 'Pending') {
      return 'status_pending'.tr;
    }
    if (status == 'Rejected') {
      return 'status_rejected'.tr;
    }
    if (status == 'Blocked') {
      return 'status_blocked'.tr;
    }
    if (status == 'Active') {
      return 'status_active'.tr;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_admin_users'.tr), centerTitle: true),
      body: Obx(
        () => Stack(
          children: [
            if (controller.isUsersLoading.value)
              const UserListShimmer()
            else
              ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: controller.usersList.length,
                itemBuilder: (context, index) {
                  final user = controller.usersList[index];
                  final isBlocked = user['status'] == 'Blocked';
                  final isPending = user['status'] == 'Pending';

                  return Card(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isBlocked
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                        child: Icon(
                          user['type'] == 'Employer'
                              ? Icons.business
                              : Icons.person,
                          color: isBlocked ? Colors.red : Colors.green,
                        ),
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${_localizedUserType(user['type'])} - ${_localizedStatus(user['status'])}',
                      ),
                      trailing: Wrap(
                        spacing: 2.w,
                        children: [
                          if (isPending)
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: controller.isActionLoading.value
                                  ? null
                                  : () =>
                                      controller.approveCompany(user['id']),
                            ),
                          IconButton(
                            icon: const Icon(Icons.block, color: Colors.red),
                            tooltip: 'btn_reject'.tr,
                            onPressed: controller.isActionLoading.value
                                ? null
                                : () => controller.rejectCompany(user['id']),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fade(duration: 300.ms)
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
