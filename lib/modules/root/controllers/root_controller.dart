import 'package:ai_job_matcher/modules/employer/candidates/views/candidates_view.dart';
import 'package:ai_job_matcher/modules/employer/post_job/views/post_job_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../applications/views/applications_view.dart';
import '../../employer/employer_dashboard/views/employer_dashboard_view.dart';
import '../../profile/views/profile_view.dart';
import '../../seeker_home/views/seeker_home_view.dart';

// هنا سنستورد صفحات الـ Views التي سنعرضها (مؤقتاً سنضع Placeholder)

class RootController extends GetxController {
  final currentIndex = 0.obs;

  final isJobSeeker = true;

  late final List<Widget> pages;

  late final List<Widget> navItems;

  @override
  void onInit() {
    super.onInit();
    _initTabs();
  }

  void _initTabs() {
    if (isJobSeeker) {
      // === واجهة الباحث عن عمل ===
      pages = [
        const SeekerHomeView(),
        const ApplicationsView(),
        const ProfileView(),
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.house, 'nav_home'),
        _buildIcon(FontAwesomeIcons.briefcase, 'nav_jobs'),
        _buildIcon(FontAwesomeIcons.user, 'nav_profile'),
      ];
    } else {
      // === واجهة الشركة ===
      pages = [
        const EmployerDashboardView(),
        const PostJobView(),
        const CandidatesView(),
        const ProfileView(),
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.chartPie, 'nav_home'), // Dashboard
        _buildIcon(FontAwesomeIcons.plus, 'Post'),
        _buildIcon(FontAwesomeIcons.users, 'nav_candidates'),
        _buildIcon(FontAwesomeIcons.building, 'nav_profile'),
      ];
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Widget _buildIcon(IconData icon, String tooltip) {
    return Icon(icon, size: 26, color: Colors.white);
  }
}