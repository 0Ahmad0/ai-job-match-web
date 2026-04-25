import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'session_manager.dart';

enum UserRole { jobSeeker, company, admin }

enum UserStatus { pending, approved, rejected }

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final SessionManager _sessionManager;

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorKey = ''.obs;
  final RxMap<String, String> errorParams = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _sessionManager = Get.find<SessionManager>();
    _configurePersistence();
    _restoreSessionFromStorage();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  /// Restore session from local storage
  void _restoreSessionFromStorage() {
    final storedSession = _sessionManager.getSession();
    if (storedSession != null) {
      developer.log(
        'Session restored from storage: uid=${storedSession['uid']}',
        name: 'AuthService',
      );
    }
  }

  Future<void> _configurePersistence() async {
    if (!kIsWeb) {
      return;
    }

    try {
      await _auth.setPersistence(Persistence.SESSION);
      developer.log(
        'Firebase Auth persistence set to SESSION for web.',
        name: 'AuthService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to set auth persistence: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _onAuthStateChanged(User? user) {
    firebaseUser.value = user;
    developer.log(
      'Auth state changed: ${user?.uid ?? 'No user'}',
      name: 'AuthService',
    );
  }

  bool get isLoggedIn => firebaseUser.value != null;

  bool get isEmailVerified => firebaseUser.value?.emailVerified ?? false;

  String? get currentUserId => firebaseUser.value?.uid;

  String get localizedError {
    if (errorKey.value.isEmpty) {
      return 'auth_err_unknown'.tr;
    }
    return errorKey.value.trParams(errorParams);
  }

  void _setError(String key, [Map<String, String>? params]) {
    errorKey.value = key;
    errorParams
      ..clear()
      ..addAll(params ?? const <String, String>{});
  }

  void _clearError() {
    errorKey.value = '';
    errorParams.clear();
  }

  Future<bool> register({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
    String? companyName,
    String? aboutYou,
  }) async {
    try {
      isLoading.value = true;
      _clearError();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = userCredential.user;

      if (user == null) {
        _setError('auth_err_registration_no_user');
        return false;
      }

      final displayName = fullName?.trim().isNotEmpty == true
          ? fullName!.trim()
          : companyName?.trim();
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
      }

      final isJobSeeker = role == UserRole.jobSeeker;
      final status = isJobSeeker
          ? UserStatus.approved.name
          : UserStatus.pending.name;
      final userData = <String, dynamic>{
        'uid': user.uid,
        'email': user.email,
        'role': role.name,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (isJobSeeker) {
        userData['fullName'] = fullName?.trim() ?? '';
        userData['emailVerified'] = user.emailVerified;
      } else {
        userData['companyName'] = companyName?.trim() ?? '';
      }

      // Add optional aboutYou field if provided
      if (aboutYou != null && aboutYou.trim().isNotEmpty) {
        final trimmedAbout = aboutYou.trim();
        userData['aboutYou'] = trimmedAbout;
        userData['bio'] = trimmedAbout;
      }

      await _firestore.collection('users').doc(user.uid).set(userData);

      // Save session to local storage after registration
      await _sessionManager.saveSession(
        uid: user.uid,
        role: role.name,
        status: status,
        isEmailVerified: user.emailVerified,
      );

      if (isJobSeeker && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_handleAuthExceptionKey(e));
      return false;
    } catch (e, stackTrace) {
      _setError('auth_err_registration_generic', {'error': e.toString()});
      developer.log(
        'Registration error: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      _clearError();
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await user.reload();
        firebaseUser.value = _auth.currentUser;

        // Save session to local storage
        final userData = await getCurrentUserData();
        if (userData != null) {
          final role = (userData['role'] as String?) ?? '';
          final status = (userData['status'] as String?) ?? 'pending';
          await _sessionManager.saveSession(
            uid: user.uid,
            role: role,
            status: status,
            isEmailVerified: user.emailVerified,
          );
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_handleAuthExceptionKey(e));
      return false;
    } catch (e, stackTrace) {
      _setError('auth_err_login_generic', {'error': e.toString()});
      developer.log(
        'Login error: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendEmailVerification() async {
    try {
      _clearError();
      final user = _auth.currentUser;
      if (user == null) {
        _setError('auth_err_no_user_logged_in');
        return false;
      }
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      return true;
    } catch (e, stackTrace) {
      _setError('auth_err_send_verification', {'error': e.toString()});
      developer.log(
        'Send verification error: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _clearError();
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_handleAuthExceptionKey(e));
      return false;
    } catch (e, stackTrace) {
      _setError('auth_err_password_reset', {'error': e.toString()});
      developer.log(
        'Password reset error: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    } catch (e, stackTrace) {
      developer.log(
        'Failed to get user document: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> refreshCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    await user.reload();
    firebaseUser.value = _auth.currentUser;
  }

  /// Refresh token and update session
  /// Returns true if refresh successful, false if token expired/invalid
  Future<bool> refreshToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        await _sessionManager.clearSession();
        return false;
      }

      // Get ID token with refresh
      final idToken = await user.getIdToken(true);
      if (idToken == null) {
        await _sessionManager.clearSession();
        return false;
      }

      developer.log('Token refreshed successfully', name: 'AuthService');
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Token refresh failed: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
      await _sessionManager.clearSession();
      return false;
    }
  }

  /// Verify current session validity and update if needed
  Future<bool> verifyAndUpdateSession() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        await _sessionManager.clearSession();
        return false;
      }

      // Refresh user to get latest state
      await user.reload();
      firebaseUser.value = _auth.currentUser;

      // Get fresh user data from Firestore
      final userData = await getCurrentUserData();
      if (userData == null) {
        await _sessionManager.clearSession();
        return false;
      }

      // Update session with latest data
      final role = (userData['role'] as String?) ?? '';
      final status = (userData['status'] as String?) ?? 'pending';
      await _sessionManager.saveSession(
        uid: user.uid,
        role: role,
        status: status,
        isEmailVerified: user.emailVerified,
      );

      developer.log('Session verified and updated', name: 'AuthService');
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Session verification failed: $e',
        name: 'AuthService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _sessionManager.clearSession();
  }

  String _handleAuthExceptionKey(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'auth_err_weak_password';
      case 'email-already-in-use':
        return 'auth_err_email_already_used';
      case 'user-not-found':
        return 'auth_err_user_not_found';
      case 'wrong-password':
      case 'invalid-credential':
        return 'auth_err_wrong_password';
      case 'invalid-email':
        return 'auth_err_invalid_email';
      case 'operation-not-allowed':
        return 'auth_err_operation_not_allowed';
      case 'too-many-requests':
        return 'auth_err_too_many_requests';
      default:
        return 'auth_err_unknown';
    }
  }
}
