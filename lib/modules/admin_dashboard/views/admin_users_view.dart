import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminUsersView extends GetView<AdminDashboardController> {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_admin_users'.tr), centerTitle: true),
      body: Obx(() => ListView.builder(
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
                backgroundColor: isBlocked ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                child: Icon(
                  user['type'] == 'Employer' ? Icons.business : Icons.person,
                  color: isBlocked ? Colors.red : Colors.green,
                ),
              ),
              title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${user['type']} • ${user['status']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPending)
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => controller.approveCompany(user['id']),
                    ),

                  // زر التجميد / فك التجميد (Toggle)
                  IconButton(
                    icon: Icon(
                      isBlocked ? Icons.lock_open : Icons.block,
                      color: isBlocked ? Colors.green : Colors.red,
                    ),
                    tooltip: isBlocked ? 'btn_unblock'.tr : 'btn_block'.tr,
                    onPressed: () => controller.toggleUserStatus(user['id'], user['status']),
                  ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}