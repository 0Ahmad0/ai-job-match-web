import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/employer_dashboard_controller.dart';
import 'widgets/emp_stat_card.dart';
import 'widgets/applicant_tile_widget.dart';

class EmployerDashboardView extends GetView<EmployerDashboardController> {
  const EmployerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('emp_dash_title'.tr),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 1.25,
              children: [
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: Obx(() => EmpStatCard(
                    title: 'stat_active_jobs'.tr,
                    count: controller.activeJobsCount.toString(),
                    icon: FontAwesomeIcons.briefcase,
                    color: Colors.blue,
                  )),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Obx(() => EmpStatCard(
                    title: 'stat_new_candidates'.tr,
                    count: controller.newCandidatesCount.toString(),
                    icon: FontAwesomeIcons.users,
                    color: Colors.orange,
                  )),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Obx(() => EmpStatCard(
                    title: 'stat_shortlisted'.tr,
                    count: controller.shortlistedCount.toString(),
                    icon: FontAwesomeIcons.heart,
                    color: Colors.red,
                  )),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Obx(() => EmpStatCard(
                    title: 'stat_interviews_scheduled'.tr,
                    count: controller.interviewsCount.toString(),
                    icon: FontAwesomeIcons.calendarCheck,
                    color: Colors.green,
                  )),
                ),
              ],
            ),

            30.verticalSpace,

            // 2. Recent Applicants Title
            FadeInLeft(
              delay: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('lbl_recent_applicants'.tr, style: context.textTheme.headlineSmall?.copyWith(fontSize: 18.sp)),
                  Text('lbl_view_all'.tr, style: TextStyle(color: context.theme.primaryColor, fontSize: 12.sp)),
                ],
              ),
            ),

            15.verticalSpace,

            // 3. Applicants List
            Obx(() => Column(
              children: controller.recentApplicants.map((app) {
                return FadeInUp(
                  child: ApplicantTileWidget(
                    name: app['name'],
                    job: app['job'],
                    matchScore: app['match'],
                    time: app['time'],
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }
}