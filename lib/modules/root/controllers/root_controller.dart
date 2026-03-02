import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Seeker Pages ---
import '../../admin_dashboard/views/admin_jobs_view.dart';
import '../../admin_dashboard/views/admin_users_view.dart';
import '../../seeker_home/views/seeker_home_view.dart';
import '../../applications/views/applications_view.dart';
import '../../jobs/views/jobs_view.dart'; // صفحة الوظائف للبحث
import '../../ai_analyzer/views/ai_analyzer_view.dart'; // المحلل الذكي

// --- Employer Pages ---
import '../../employer/employer_dashboard/views/employer_dashboard_view.dart';
import '../../employer/post_job/views/post_job_view.dart';
import '../../employer/candidates/views/candidates_view.dart';

// --- Admin Pages ---
import '../../admin_dashboard/views/admin_dashboard_view.dart'; // تأكد من استيراد الأدمن

// --- Shared Pages ---
import '../../profile/views/profile_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;

  // 0: Seeker, 1: Employer, 2: Admin
  // (لاحقاً خذ هذه القيمة من StorageService بعد تسجيل الدخول)
  final userRole = 2.obs;

  late final List<Widget> pages;
  late final List<Widget> navItems;

  @override
  void onInit() {
    super.onInit();
    _initTabs();
  }

  void _initTabs() {
    // ==========================================
    // 1️⃣ Seeker (الباحث عن عمل)
    // ==========================================
    if (userRole.value == 0) {
      pages = [
        const SeekerHomeView(), // الرئيسية
        const AiAnalyzerView(), // المحلل الذكي
        const JobsView(), // البحث عن وظائف
        const ApplicationsView(), // طلباتي (Track)
        const ProfileView(), // البروفايل
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.house, 'nav_home'),
        _buildIcon(FontAwesomeIcons.wandMagicSparkles, 'nav_ai'),
        _buildIcon(FontAwesomeIcons.briefcase, 'nav_jobs'),
        _buildIcon(FontAwesomeIcons.fileContract, 'lbl_my_applications'),
        _buildIcon(FontAwesomeIcons.user, 'nav_profile'),
      ];
    }
    // ==========================================
    // 2️⃣ Employer (صاحب العمل)
    // ==========================================
    else if (userRole.value == 1) {
      pages = [
        const EmployerDashboardView(),
        const PostJobView(),
        const CandidatesView(),
        const ProfileView(), // نستخدم نفس البروفايل مؤقتاً
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.chartPie, 'nav_home'), // Dashboard
        _buildIcon(FontAwesomeIcons.plus, 'Post Job'),
        _buildIcon(FontAwesomeIcons.users, 'Candidates'),
        _buildIcon(FontAwesomeIcons.building, 'Profile'),
      ];
    }
    // ==========================================
    // 3️⃣ Admin (الأدمن) - "الجديد" 👑
    // ==========================================
    else {
      pages = [
        const AdminDashboardView(),

        const AdminUsersView(),
        const AdminJobsView(),
        const ProfileView(),
      ];

      navItems = [
        _buildIcon(FontAwesomeIcons.gaugeHigh, 'Dashboard'),

        _buildIcon(FontAwesomeIcons.usersGear, 'Users'),

        _buildIcon(FontAwesomeIcons.listCheck, 'Jobs'),

        _buildIcon(FontAwesomeIcons.userShield, 'Admin Profile'),
      ];
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Widget _buildIcon(IconData icon, String tooltip) {
    // لون الأيقونة أبيض لأن خلفية الـ CurvedNavBar ستكون ملونة (PrimaryColor)
    return Icon(icon, size: 26, color: Colors.white);
  }
}
