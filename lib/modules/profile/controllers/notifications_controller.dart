import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/models/notification_model.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot>? _notificationsSub;

  @override
  void onInit() {
    super.onInit();
    _startListener();
  }

  void _startListener() {
    final user = _auth.currentUser;
    if (user == null) {
      notifications.clear();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    _notificationsSub = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .listen((snapshot) {
      try {
        final items = snapshot.docs.map((doc) {
          return NotificationModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
        }).toList();

        notifications.assignAll(items);
        unreadCount.value = items.where((n) => !n.isRead).length;
      } catch (e) {
        print('Failed to load notifications: $e');
      } finally {
        isLoading.value = false;
      }
    });
  }

  Future<void> markAsRead(String notificationId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'is_read': true});

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index].isRead = true;
        notifications.refresh();
        unreadCount.value = notifications.where((n) => !n.isRead).length;
      }
    } catch (e) {
      print('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final batch = _firestore.batch();
      for (final notification in notifications.where((n) => !n.isRead)) {
        final ref = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .doc(notification.id);
        batch.update(ref, {'is_read': true});
      }
      await batch.commit();

      for (var n in notifications) {
        n.isRead = true;
      }
      notifications.refresh();
      unreadCount.value = 0;
    } catch (e) {
      print('Failed to mark all notifications as read: $e');
    }
  }

  Future<void> removeNotification(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(id)
          .delete();

      notifications.removeWhere((n) => n.id == id);
      unreadCount.value = notifications.where((n) => !n.isRead).length;
    } catch (e) {
      print('Failed to remove notification: $e');
    }
  }

  Future<void> clearAll() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final batch = _firestore.batch();
      for (final notification in notifications) {
        final ref = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .doc(notification.id);
        batch.delete(ref);
      }
      await batch.commit();
      notifications.clear();
      unreadCount.value = 0;
    } catch (e) {
      print('Failed to clear all notifications: $e');
    }
  }

  @override
  void onClose() {
    _notificationsSub?.cancel();
    super.onClose();
  }
}