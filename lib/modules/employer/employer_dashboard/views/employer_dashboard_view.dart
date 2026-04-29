import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/common/shimmer_skeletons.dart';
import '../../../../routes/app_routes.dart';
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
          IconButton(
            tooltip: 'lbl_post_job'.tr,
            onPressed: () => Get.toNamed(Routes.COMPANY_POST_JOB),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Obx(() {
          final isLoading = controller.isLoading.value;
          final activeJobsCount = controller.activeJobsCount.value;
          final newCandidatesCount = controller.newCandidatesCount.value;
          final shortlistedCount = controller.shortlistedCount.value;
          final interviewsCount = controller.interviewsCount.value;
          final recentApplicants =
              controller.recentApplicants.toList(growable: false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading) const CardListShimmer(itemCount: 2),
              if (!isLoading)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth < 700 ? 2 : 4;
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
                          child: EmpStatCard(
                            title: 'stat_active_jobs'.tr,
                            count: activeJobsCount.toString(),
                            icon: FontAwesomeIcons.briefcase,
                            color: Colors.blue,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: EmpStatCard(
                            title: 'stat_new_candidates'.tr,
                            count: newCandidatesCount.toString(),
                            icon: FontAwesomeIcons.users,
                            color: Colors.orange,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: EmpStatCard(
                            title: 'stat_shortlisted'.tr,
                            count: shortlistedCount.toString(),
                            icon: FontAwesomeIcons.heart,
                            color: Colors.red,
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: EmpStatCard(
                            title: 'stat_interviews_scheduled'.tr,
                            count: interviewsCount.toString(),
                            icon: FontAwesomeIcons.calendarCheck,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              30.verticalSpace,
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
              if (!isLoading && recentApplicants.isEmpty)
                AppStateCard(
                  icon: Icons.group_outlined,
                  title: 'lbl_recent_applicants'.tr,
                  message: 'msg_no_applicants'.tr,
                ),
              if (!isLoading)
                Column(
                  children: recentApplicants.map((app) {
                    return FadeInUp(
                      child: ApplicantTileWidget(
                        name: (app['name'] as String?) ?? '',
                        job: (app['job'] as String?) ?? '',
                        matchScore: (app['match'] as int?) ?? 0,
                        time: (app['time'] as String?) ?? '-',
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        }),
      ),
    );
  }
}
