import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as developer;

import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool get isLoading => _authService.isLoading;
  String get errorKey =>
      _authService.errorKey.value.isEmpty ? 'auth_err_unknown' : _authService.errorKey.value;
  Map<String, String> get errorParams => Map<String, String>.from(_authService.errorParams);

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _authService.login(email: email, password: password);
  }

  Future<bool> register({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
    String? companyName,
    String? aboutYou,
  }) async {
    return _authService.register(
      email: email,
      password: password,
      role: role,
      fullName: fullName,
      companyName: companyName,
      aboutYou: aboutYou,
    );
  }

  Future<bool> sendPasswordResetEmail(String email) {
    return _authService.sendPasswordResetEmail(email);
  }

  Future<bool> sendEmailVerification() {
    return _authService.sendEmailVerification();
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> refreshCurrentUser() async {
    await _authService.refreshCurrentUser();
  }

  // TEMP_ADMIN_SEED_START (safe to delete after one-time use)
  Future<void> seedAdminAccount() async {
    try {
      developer.log('Starting temporary admin seed.', name: 'AuthController');
      UserCredential userCredential;
      try {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: 'admin@admin.com',
          password: '123Admin@',
        );
      } on FirebaseAuthException catch (e) {
        // If auth user already exists, recover by signing in and seeding Firestore.
        if (e.code != 'email-already-in-use') {
          rethrow;
        }

        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: 'admin@admin.com',
          password: '123Admin@',
        );
      }

      final uid = userCredential.user?.uid;
      if (uid == null) {
        Get.snackbar('err_title'.tr, 'msg_admin_seed_failed'.tr);
        return;
      }

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': 'admin@admin.com',
        'role': 'admin',
        'status': 'approved',
      });

      developer.log('Temporary admin seed completed for uid=$uid', name: 'AuthController');
      await _firebaseAuth.signOut();
      developer.log('Signed out after temporary admin seed.', name: 'AuthController');

      Get.snackbar(
        'seed_admin_success_title'.tr,
        'msg_admin_seed_success'.tr,
      );
    } on FirebaseAuthException catch (e) {
      developer.log('Temporary admin seed auth error: ${e.code}', name: 'AuthController');
      final message = e.code == 'wrong-password'
          ? 'msg_admin_seed_password_conflict'.tr
          : 'msg_admin_seed_failed_with_error'.trParams({
              'error': e.code,
            });
      Get.snackbar('err_title'.tr, message);
    } on FirebaseException catch (e) {
      developer.log('Temporary admin seed firebase error: ${e.code}', name: 'AuthController');
      Get.snackbar(
        'err_title'.tr,
        'msg_admin_seed_failed_with_error'.trParams({
          'error': e.code,
        }),
      );
    } catch (e) {
      developer.log('Temporary admin seed unexpected error: $e', name: 'AuthController');
      Get.snackbar(
        'err_title'.tr,
        'msg_admin_seed_failed_with_error'.trParams({
          'error': e.toString(),
        }),
      );
    }
  }
  // TEMP_ADMIN_SEED_END

  Future<String?> resolvePostLoginRole() async {
    final data = await _authService.getCurrentUserData();
    if (data == null) {
      developer.log(
        'No Firestore user document found after login.',
        name: 'AuthController',
      );
      return null;
    }

    final role = (data['role'] as String?) ?? '';
    switch (role) {
      case 'admin':
        return 'admin';
      case 'company':
        return 'company';
      case 'jobSeeker':
        return 'jobSeeker';
      default:
        return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    return _authService.getCurrentUserData();
  }

  bool get isEmailVerified => _authService.isEmailVerified;

  Future<Map<String, dynamic>?> resolveSessionDestination() async {
    await refreshCurrentUser();

    final userData = await getCurrentUserData();
    if (userData == null) {
      developer.log(
        'resolveSessionDestination: missing Firestore user document',
        name: 'AuthController',
      );
      return null;
    }

    final role = (userData['role'] as String?) ?? '';
    final status = (userData['status'] as String?) ?? 'pending';
    developer.log(
      'resolveSessionDestination role=$role status=$status emailVerified=$isEmailVerified',
      name: 'AuthController',
    );

    if (role == 'jobSeeker' && !isEmailVerified) {
      return {
        'route': Routes.AUTH_OTP,
        'arguments': null,
      };
    }

    if (role == 'company' && status != 'approved') {
      final messageKey = status == 'rejected'
          ? 'company_rejected_message'
          : 'company_pending_message';
      final titleKey = status == 'rejected'
          ? 'company_rejected_title'
          : 'company_pending_title';
      return {
        'route': Routes.AUTH_STATUS,
        'arguments': {
          'titleKey': titleKey,
          'messageKey': messageKey,
        },
      };
    }

    if (role == 'admin' || role == 'company' || role == 'jobSeeker') {
      return {
        'route': Routes.ROOT,
        'arguments': {
          'role': role,
          'index': 0,
        },
      };
    }

    return null;
  }
}
