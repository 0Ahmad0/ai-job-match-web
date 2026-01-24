enum NotificationType { job, system, application }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time; // مثلاً: 2h ago
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}