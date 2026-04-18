import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../admin_dashboard/views/admin_dashboard_view.dart';
import '../../admin_dashboard/views/admin_jobs_view.dart';
import '../../admin_dashboard/views/admin_users_view.dart';
import '../../ai_analyzer/views/ai_analyzer_view.dart';
import '../../applications/views/applications_view.dart';
import '../../employer/candidates/views/candidates_view.dart';
import '../../employer/employer_dashboard/views/employer_dashboard_view.dart';
import '../../employer/post_job/views/post_job_view.dart';
import '../../jobs/views/jobs_view.dart';
import '../../profile/views/profile_view.dart';
import '../../seeker_home/views/seeker_home_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;
  final userRole = 'jobSeeker'.obs;
  final tabsVersion = 0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Widget> pages = <Widget>[];
  List<Widget> navItems = <Widget>[];

  @override
  void onInit() {
    super.onInit();
    _resolveEntryContext();
    _initTabs();
  }

  @override
  void onReady() {
    super.onReady();
    _syncRoleFromSession();
  }

  void _resolveEntryContext() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final role = args['role'] as String?;
      final index = args['index'] as int?;
      if (role != null && role.isNotEmpty) {
        userRole.value = role;
      }
      if (index != null) {
        currentIndex.value = index;
      }
    }

    if (Get.currentRoute == Routes.COMPANY_PANEL) {
      userRole.value = 'company';
    } else if (Get.currentRoute == Routes.ADMIN_DASHBOARD_ALIAS) {
      userRole.value = 'admin';
    } else if (Get.currentRoute == Routes.JOB_SEEKER_HOME) {
      userRole.value = 'jobSeeker';
    }

    developer.log(
      'Root resolveEntryContext route=${Get.currentRoute} args=$args role=${userRole.value} index=${currentIndex.value}',
      name: 'RootController',
    );
  }

  void _initTabs() {
    if (userRole.value == 'jobSeeker') {
      pages = const [
        SeekerHomeView(),
        AiAnalyzerView(),
        JobsView(),
        ApplicationsView(),
        ProfileView(),
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.house),
        _buildIcon(FontAwesomeIcons.wandMagicSparkles),
        _buildIcon(FontAwesomeIcons.briefcase),
        _buildIcon(FontAwesomeIcons.fileContract),
        _buildIcon(FontAwesomeIcons.user),
      ];
    } else if (userRole.value == 'company') {
      pages = const [
        EmployerDashboardView(),
        PostJobView(),
        CandidatesView(),
        ProfileView(),
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.chartPie),
        _buildIcon(FontAwesomeIcons.plus),
        _buildIcon(FontAwesomeIcons.users),
        _buildIcon(FontAwesomeIcons.building),
      ];
    } else {
      pages = const [
        AdminDashboardView(),
        AdminUsersView(),
        AdminJobsView(),
        ProfileView(),
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.gaugeHigh),
        _buildIcon(FontAwesomeIcons.usersGear),
        _buildIcon(FontAwesomeIcons.listCheck),
        _buildIcon(FontAwesomeIcons.userShield),
      ];
    }

    if (currentIndex.value >= pages.length) {
      currentIndex.value = 0;
    }
    tabsVersion.value++;
  }

  Future<void> _syncRoleFromSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      developer.log(
        'Root sync skipped: no authenticated user.',
        name: 'RootController',
      );
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final sessionRole = userDoc.data()?['role'] as String?;
      if (sessionRole == null || sessionRole.isEmpty || sessionRole == userRole.value) {
        developer.log(
          'Root sync role stable: current=${userRole.value} session=$sessionRole',
          name: 'RootController',
        );
        return;
      }

      developer.log(
        'Root role mismatch corrected from ${userRole.value} to $sessionRole',
        name: 'RootController',
      );
      userRole.value = sessionRole;
      currentIndex.value = 0;
      _initTabs();
    } catch (e, stackTrace) {
      developer.log(
        'Root sync failed: $e',
        name: 'RootController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Widget _buildIcon(IconData icon) {
    return Icon(icon, size: 26, color: Colors.white);
  }
}
