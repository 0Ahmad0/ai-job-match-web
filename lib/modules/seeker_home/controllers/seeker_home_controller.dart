import 'dart:async';
import 'dart:developer' as developer;

import 'package:ai_job_matcher/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SeekerHomeController extends GetxController {
  final userName = ''.obs;
  final userImage = ''.obs;
  final userRole = 'jobSeeker'.obs;
  final isHeaderLoading = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isNavigating = false;

  StreamSubscription<User?>? _userSub;

  @override
  void onInit() {
    super.onInit();
    loadHeaderData();
    // Listen to auth user changes so profile updates (name/image) reflect in home header
    _userSub = _auth.userChanges().listen((_) async {
      await loadHeaderData();
    });
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }

  Future<void> loadHeaderData() async {
    final user = _auth.currentUser;
    if (user == null) {
      userName.value = 'Guest';
      userImage.value = '';
      isHeaderLoading.value = false;
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? const <String, dynamic>{};
      userName.value =
          (data['fullName'] as String?)?.trim().isNotEmpty == true
              ? (data['fullName'] as String).trim()
              : (data['companyName'] as String?)?.trim().isNotEmpty == true
                  ? (data['companyName'] as String).trim()
                  : (user.displayName?.trim().isNotEmpty == true
                      ? user.displayName!.trim()
                      : (user.email?.split('@').first ?? 'User'));
      userImage.value = (data['profile_image_url'] as String?) ?? '';
      userRole.value = (data['role'] as String?) ?? 'jobSeeker';
    } catch (e, stackTrace) {
      developer.log(
        'Failed to load seeker home header: $e',
        name: 'SeekerHomeController',
        error: e,
        stackTrace: stackTrace,
      );
      userName.value = user.displayName ?? user.email?.split('@').first ?? 'User';
      userImage.value = '';
    } finally {
      isHeaderLoading.value = false;
    }
  }

  void openProfile() {
    _navigateSafely(Routes.PROFILE);
  }

  void onUploadCvTap() {
    _navigateSafely(Routes.AI_ANALYZER);
  }

  void onCreateCvTap() {
    _navigateSafely(Routes.CV_ENTRY);
  }

  void _navigateSafely(String route, {dynamic arguments}) {
    if (_isNavigating || isClosed) return;
    _isNavigating = true;

    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      try {
        Get.toNamed(route, arguments: arguments)?.whenComplete(() {
          _isNavigating = false;
        });
      } catch (_) {
        _isNavigating = false;
      }
    });
  }
}
