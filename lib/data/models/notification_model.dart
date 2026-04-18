import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum NotificationType { job, system, application }

enum NotificationStatus { applied, underReview, interviewScheduled, accepted, rejected, system }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final NotificationStatus? notificationStatus;
  final String? applicationId;
  final String? jobId;
  final String? jobTitle;
  final String? companyName;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.notificationStatus,
    this.applicationId,
    this.jobId,
    this.jobTitle,
    this.companyName,
    this.isRead = false,
  });

  factory NotificationModel.fromFirestore(String id, Map<String, dynamic> data) {
    return NotificationModel(
      id: id,
      title: (data['title'] as String?) ?? '',
      body: (data['body'] as String?) ?? '',
      timestamp: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: _mapType((data['type'] as String?) ?? 'system'),
      notificationStatus: _mapNotificationStatus((data['notification_status'] as String?) ?? ''),
      applicationId: data['application_id'] as String?,
      jobId: data['job_id'] as String?,
      jobTitle: data['job_title'] as String?,
      companyName: data['company_name'] as String?,
      isRead: (data['is_read'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'created_at': timestamp.toIso8601String(),
      'type': type.name,
      if (notificationStatus != null) 'notification_status': notificationStatus!.name,
      if (applicationId != null) 'application_id': applicationId,
      if (jobId != null) 'job_id': jobId,
      if (jobTitle != null) 'job_title': jobTitle,
      if (companyName != null) 'company_name': companyName,
      'is_read': isRead,
    };
  }

  static NotificationType _mapType(String raw) {
    switch (raw) {
      case 'job':
        return NotificationType.job;
      case 'application':
        return NotificationType.application;
      case 'system':
      default:
        return NotificationType.system;
    }
  }

  static NotificationStatus? _mapNotificationStatus(String raw) {
    switch (raw) {
      case 'applied':
        return NotificationStatus.applied;
      case 'under_review':
        return NotificationStatus.underReview;
      case 'interview_scheduled':
        return NotificationStatus.interviewScheduled;
      case 'accepted':
        return NotificationStatus.accepted;
      case 'rejected':
        return NotificationStatus.rejected;
      default:
        return null;
    }
  }

  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inSeconds < 60) return 'lbl_just_now'.tr;
    if (diff.inMinutes < 60) return 'lbl_minutes_ago'.trParams({'minutes': diff.inMinutes.toString()});
    if (diff.inHours < 24) return 'lbl_hours_ago'.trParams({'hours': diff.inHours.toString()});
    if (diff.inDays < 7) return 'lbl_days_ago'.trParams({'days': diff.inDays.toString()});
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
  }
}