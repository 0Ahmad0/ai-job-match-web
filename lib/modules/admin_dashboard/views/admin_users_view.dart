import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/shimmer_skeletons.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminUsersView extends GetView<AdminDashboardController> {
  const AdminUsersView({super.key});

  String _localizedUserType(String role) {
    if (role == 'company') {
      return 'user_type_employer'.tr;
    }
    return 'user_type_seeker'.tr;
  }

  String _localizedStatus(String status) {
    if (status == 'pending') {
      return 'status_pending'.tr;
    }
    if (status == 'rejected') {
      return 'status_rejected'.tr;
    }
    if (status == 'blocked') {
      return 'status_blocked'.tr;
    }
    return 'status_approved_user'.tr;
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
            else if (controller.usersList.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Text('admin_users_empty'.tr, textAlign: TextAlign.center),
                ),
              )
            else
              ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: controller.usersList.length,
                itemBuilder: (context, index) {
                  final user = controller.usersList[index];
                  final status = (user['status'] as String? ?? '').toLowerCase();
                  final role = (user['role'] as String? ?? '').toLowerCase();
                  final isBlocked = status == 'blocked';
                  final isPendingCompany = role == 'company' && status == 'pending';

                  return Card(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isBlocked
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                        child: Icon(
                          role == 'company' ? Icons.business : Icons.person,
                          color: isBlocked ? Colors.red : Colors.green,
                        ),
                      ),
                      title: Text(
                        user['name'] as String? ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${_localizedUserType(role)} - ${_localizedStatus(status)}'),
                          if ((user['email'] as String?)?.isNotEmpty == true)
                            Text(
                              user['email'] as String,
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                            ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 2.w,
                        children: [
                          if (isPendingCompany)
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              tooltip: 'btn_approve'.tr,
                              onPressed: controller.isActionLoading.value
                                  ? null
                                  : () => controller.approveCompany(user['id'] as String),
                            ),
                          if (isPendingCompany)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.orange),
                              tooltip: 'btn_reject'.tr,
                              onPressed: controller.isActionLoading.value
                                  ? null
                                  : () => controller.rejectCompany(user['id'] as String),
                            ),
                          IconButton(
                            icon: Icon(
                              isBlocked ? Icons.lock_open : Icons.block,
                              color: isBlocked ? Colors.green : Colors.red,
                            ),
                            tooltip: isBlocked ? 'btn_unblock_user'.tr : 'btn_block_user'.tr,
                            onPressed: controller.isActionLoading.value
                                ? null
                                : () => isBlocked
                                    ? controller.unblockUser(user['id'] as String)
                                    : controller.blockUser(user['id'] as String),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(duration: 300.ms).slideY(begin: 0.08, end: 0);
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
