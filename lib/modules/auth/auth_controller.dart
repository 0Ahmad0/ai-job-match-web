import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

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

    if (status == 'blocked') {
      return {
        'route': Routes.AUTH_STATUS,
        'arguments': {
          'titleKey': 'account_blocked_title',
          'messageKey': 'account_blocked_message',
          'showRefresh': false,
        },
      };
    }

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
