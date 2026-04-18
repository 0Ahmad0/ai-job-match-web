import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../data/services/session_manager.dart';
import 'app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final SessionManager _sessionManager = Get.find<SessionManager>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    developer.log('AuthMiddleware checking route: $route', name: 'AuthMiddleware');
    
    // Allow access if user is authenticated
    if (_sessionManager.hasActiveSession()) {
      developer.log('Active session found, allowing access', name: 'AuthMiddleware');
      return null;
    }

    developer.log('No active session, redirecting to login', name: 'AuthMiddleware');
    return RouteSettings(name: Routes.AUTH_LOGIN);
  }
}

class GuestMiddleware extends GetMiddleware {
  final SessionManager _sessionManager = Get.find<SessionManager>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    developer.log('GuestMiddleware checking route: $route', name: 'GuestMiddleware');
    
    // Redirect to appropriate page if user is already authenticated
    if (_sessionManager.hasActiveSession()) {
      final role = _sessionManager.getUserRole();
      developer.log(
        'User already authenticated with role: $role, redirecting',
        name: 'GuestMiddleware',
      );

      switch (role) {
        case 'admin':
          return RouteSettings(name: Routes.ADMIN_DASHBOARD);
        case 'company':
          return RouteSettings(name: Routes.COMPANY_DASHBOARD);
        case 'jobSeeker':
          return RouteSettings(name: Routes.ROOT);
        default:
          return RouteSettings(name: Routes.ROOT);
      }
    }

    developer.log('No session found, allowing guest access', name: 'GuestMiddleware');
    return null;
  }
}
