import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/localization/localization_controller.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'widgets/admin_stat_card.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'admin_dash_title'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        actions: [
          IconButton(
            tooltip: 'language'.tr,
            onPressed: () {
              final localization = Get.find<LocalizationController>();
              final currentLang =
                  Get.locale?.languageCode ?? localization.initialLocale.languageCode;
              localization.changeLanguage(currentLang == 'ar' ? 'en' : 'ar');
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'admin_overview_title'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            15.verticalSpace,
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 700 ? 2 : 4;
                return Obx(() {
                  final totalUsers = controller.totalUsersCount.value;
                  final pendingCompanies =
                      controller.pendingCompaniesCount.value;
                  final pendingJobs = controller.pendingJobsCount.value;
                  final approvedJobs = controller.approvedJobsCount.value;

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio: 1.25,
                    children: [
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: AdminStatCard(
                          title: 'lbl_total_users'.tr,
                          value: totalUsers.toString(),
                          icon: FontAwesomeIcons.users,
                          color: Colors.blue,
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: AdminStatCard(
                          title: 'lbl_pending_companies'.tr,
                          value: pendingCompanies.toString(),
                          icon: FontAwesomeIcons.hourglassHalf,
                          color: Colors.orange,
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: AdminStatCard(
                          title: 'lbl_admin_jobs'.tr,
                          value: pendingJobs.toString(),
                          icon: FontAwesomeIcons.briefcase,
                          color: Colors.purple,
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: AdminStatCard(
                          title: 'profile_stat_active_jobs'.tr,
                          value: approvedJobs.toString(),
                          icon: FontAwesomeIcons.moneyBillWave,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
