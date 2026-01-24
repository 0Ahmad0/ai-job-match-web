import 'package:get/get.dart';

import '../../../data/models/notification_model.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyNotifications();
  }

  void _loadDummyNotifications() {
    notifications.assignAll([
      NotificationModel(
        id: '1',
        title: 'notif_type_app'.tr,
        body: 'Your application for "Flutter Developer" was viewed by HR.',
        time: '2m ago',
        type: NotificationType.application,
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'notif_type_job'.tr,
        body: 'New job match found: Senior Backend Engineer at Google.',
        time: '1h ago',
        type: NotificationType.job,
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'notif_type_sys'.tr,
        body: 'Welcome to AI Job Matcher! Complete your profile to get started.',
        time: '1d ago',
        type: NotificationType.system,
        isRead: true,
      ),
    ]);
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void removeNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    // Get.snackbar('Success', 'msg_deleted'.tr, snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 1));
  }

  void clearAll() {
    notifications.clear();
  }
}