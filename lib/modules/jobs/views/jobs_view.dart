import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/app_ui.dart';
import '../../../core/common/custom_text_field.dart';
import '../../../core/common/shimmer_skeletons.dart';
import '../../../routes/app_routes.dart';
import '../controllers/jobs_controller.dart';
import 'widgets/job_card_widget.dart';

class JobsView extends GetView<JobsController> {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_jobs_title'.tr), centerTitle: true),
      body: AppPageContainer(
        child: Column(
          children: [
            CustomTextField(
              label: 'lbl_search_jobs'.tr,
              hint: 'lbl_search_jobs'.tr,
              prefixIcon: Icons.search,
              controller: controller.searchCtrl,
              onChanged: controller.search,
            ).animate().fade(duration: 280.ms).slideY(begin: 0.05, end: 0),
            18.verticalSpace,
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const JobListShimmer();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return AppStateCard(
                    icon: Icons.error_outline,
                    title: 'err_title'.tr,
                    message: controller.errorMessage.value,
                    action: SizedBox(
                      width: 220.w,
                      child: ElevatedButton(
                        onPressed: controller.loadMatchedJobs,
                        child: Text('btn_retry'.tr),
                      ),
                    ),
                  );
                }

                if (!controller.isCvUploaded.value) {
                  return AppStateCard(
                    icon: Icons.description_outlined,
                    title: 'jobs_need_cv_title'.tr,
                    message: 'msg_upload_cv_to_see_jobs'.tr,
                    action: SizedBox(
                      width: 250.w,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.AI_ANALYZER),
                        child: Text('card_upload_title'.tr),
                      ),
                    ),
                  );
                }

                if (controller.displayedJobs.isEmpty) {
                  return AppStateCard(
                    icon: Icons.travel_explore_outlined,
                    title: 'jobs_empty_title'.tr,
                    message: 'jobs_empty_desc'.tr,
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.displayedJobs.length,
                  itemBuilder: (context, index) {
                    final job = controller.displayedJobs[index];
                    return JobCardWidget(
                      job: job,
                      isApplied: controller.hasApplied(job.id),
                      onTap: () => Get.toNamed(Routes.JOB_DETAILS, arguments: job),
                    )
                        .animate()
                        .fade(duration: 300.ms)
                        .slideY(begin: 0.08, end: 0, delay: (index * 30).ms);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
