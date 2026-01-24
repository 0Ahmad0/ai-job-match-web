import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../controllers/notifications_controller.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر هنا لأنه خاص بهذه الصفحة فقط
    final controller = Get.put(NotificationsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('lbl_notifications'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.markAllAsRead,
            tooltip: 'lbl_mark_read'.tr,
            icon: const Icon(Icons.done_all),
          ),
          IconButton(
            onPressed: controller.clearAll,
            tooltip: 'lbl_clear_all'.tr,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 80.sp, color: Colors.grey.shade300),
                20.verticalSpace,
                Text(
                  'lbl_no_notifications'.tr,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(20.r),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            return FadeInUp(
              duration: const Duration(milliseconds: 300),
              delay: Duration(milliseconds: index * 100),
              child: NotificationItemWidget(
                notification: notif,
                onDismiss: () => controller.removeNotification(notif.id),
              ),
            );
          },
        );
      }),
    );
  }
}