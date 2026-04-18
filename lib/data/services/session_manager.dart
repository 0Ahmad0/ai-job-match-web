import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer' as developer;

class SessionManager extends GetxService {
  final GetStorage _storage = GetStorage();

  static const String _userIdKey = 'session_user_id';
  static const String _userRoleKey = 'session_user_role';
  static const String _userStatusKey = 'session_user_status';
  static const String _isEmailVerifiedKey = 'session_is_email_verified';

  /// Save session data after successful login
  Future<void> saveSession({
    required String uid,
    required String role,
    required String status,
    required bool isEmailVerified,
  }) async {
    try {
      await _storage.write(_userIdKey, uid);
      await _storage.write(_userRoleKey, role);
      await _storage.write(_userStatusKey, status);
      await _storage.write(_isEmailVerifiedKey, isEmailVerified);
      developer.log(
        'Session saved: uid=$uid, role=$role',
        name: 'SessionManager',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to save session: $e',
        name: 'SessionManager',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Retrieve stored session data
  Map<String, dynamic>? getSession() {
    try {
      final uid = _storage.read<String>(_userIdKey);
      if (uid == null) {
        return null;
      }

      return {
        'uid': uid,
        'role': _storage.read<String>(_userRoleKey) ?? '',
        'status': _storage.read<String>(_userStatusKey) ?? 'pending',
        'isEmailVerified': _storage.read<bool>(_isEmailVerifiedKey) ?? false,
      };
    } catch (e, stackTrace) {
      developer.log(
        'Failed to retrieve session: $e',
        name: 'SessionManager',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Check if user has active session
  bool hasActiveSession() {
    return _storage.read<String>(_userIdKey) != null;
  }

  /// Get stored user ID
  String? getUserId() {
    return _storage.read<String>(_userIdKey);
  }

  /// Get stored user role
  String? getUserRole() {
    return _storage.read<String>(_userRoleKey);
  }

  /// Update session status (useful when admin approves company account)
  Future<void> updateSessionStatus(String newStatus) async {
    try {
      await _storage.write(_userStatusKey, newStatus);
      developer.log(
        'Session status updated: $newStatus',
        name: 'SessionManager',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to update session status: $e',
        name: 'SessionManager',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Update email verified status
  Future<void> updateEmailVerified(bool isVerified) async {
    try {
      await _storage.write(_isEmailVerifiedKey, isVerified);
      developer.log(
        'Email verified status updated: $isVerified',
        name: 'SessionManager',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to update email verified status: $e',
        name: 'SessionManager',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clear all session data (logout)
  Future<void> clearSession() async {
    try {
      await _storage.remove(_userIdKey);
      await _storage.remove(_userRoleKey);
      await _storage.remove(_userStatusKey);
      await _storage.remove(_isEmailVerifiedKey);
      developer.log('Session cleared', name: 'SessionManager');
    } catch (e, stackTrace) {
      developer.log(
        'Failed to clear session: $e',
        name: 'SessionManager',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
