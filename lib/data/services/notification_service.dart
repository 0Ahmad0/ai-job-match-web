import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/notification_model.dart';

class NotificationService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new notification for the specified user.
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    NotificationStatus? notificationStatus,
    String? applicationId,
    String? jobId,
    String? jobTitle,
    String? companyName,
  }) async {
    try {
      final notification = NotificationModel(
        id: '', // Will be set by Firestore
        title: title,
        body: body,
        timestamp: DateTime.now(),
        type: type,
        notificationStatus: notificationStatus,
        applicationId: applicationId,
        jobId: jobId,
        jobTitle: jobTitle,
        companyName: companyName,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add(notification.toFirestore());
    } catch (e) {
      // Log error but don't crash the app
      print('Failed to create notification: $e');
    }
  }

  /// Triggers a notification when a job application is submitted (for company).
  Future<void> onApplicationSubmitted({
    required String companyId,
    required String companyName,
    required String jobId,
    required String jobTitle,
    required String applicationId,
  }) async {
    await createNotification(
      userId: companyId,
      title: 'notif_new_application'.tr,
      body: 'notif_new_application_body'.trParams({
        'job': jobTitle,
      }),
      type: NotificationType.application,
      notificationStatus: NotificationStatus.applied,
      applicationId: applicationId,
      jobId: jobId,
      jobTitle: jobTitle,
      companyName: companyName,
    );
  }

  /// Triggers a notification when application status changes (for job seeker).
  Future<void> onApplicationStatusChanged({
    required String jobSeekerId,
    required String jobTitle,
    required String companyName,
    required ApplicationStatus status,
    String? interviewDate,
    String? rejectionReason,
  }) async {
    String title;
    String body;
    NotificationStatus notificationStatus;

    switch (status) {
      case ApplicationStatus.underReview:
        title = 'notif_application_under_review'.tr;
        body = 'notif_under_review_body'.trParams({'job': jobTitle, 'company': companyName});
        notificationStatus = NotificationStatus.underReview;
        break;
      case ApplicationStatus.interviewScheduled:
        title = 'notif_interview_scheduled'.tr;
        body = 'notif_interview_body'.trParams({
          'job': jobTitle,
          'company': companyName,
          'date': interviewDate ?? 'TBD',
        });
        notificationStatus = NotificationStatus.interviewScheduled;
        break;
      case ApplicationStatus.accepted:
        title = 'notif_application_accepted'.tr;
        body = 'notif_accepted_body'.trParams({'job': jobTitle, 'company': companyName});
        notificationStatus = NotificationStatus.accepted;
        break;
      case ApplicationStatus.rejected:
        title = 'notif_application_rejected'.tr;
        body = rejectionReason != null
            ? 'notif_rejected_body_with_reason'.trParams({
                'job': jobTitle,
                'company': companyName,
                'reason': rejectionReason,
              })
            : 'notif_rejected_body'.trParams({'job': jobTitle, 'company': companyName});
        notificationStatus = NotificationStatus.rejected;
        break;
      default:
        return;
    }

    await createNotification(
      userId: jobSeekerId,
      title: title,
      body: body,
      type: NotificationType.application,
      notificationStatus: notificationStatus,
    );
  }
}

enum ApplicationStatus {
  applied,
  underReview,
  interviewScheduled,
  accepted,
  rejected,
}
