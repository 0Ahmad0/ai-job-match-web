import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../controllers/jobs_controller.dart';
import 'job_details_view.dart';
import 'widgets/job_card_widget.dart';

class JobsView extends GetView<JobsController> {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    // نتأكد أن الكنترولر محقون (لأننا قد نأتي من Home)
    Get.put(JobsController());

    return Scaffold(
      appBar: AppBar(title: Text('lbl_jobs_title'.tr), centerTitle: true),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(20.r),
            child: TextField(
              controller: controller.searchCtrl,
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: 'lbl_search_jobs'.tr,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: context.isDarkMode
                    ? Colors.white10
                    : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Jobs List
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.displayedJobs.length,
                itemBuilder: (context, index) {
                  final job = controller.displayedJobs[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: JobCardWidget(
                      job: job,

                      onTap: () {
                        Get.to(() => JobDetailsView(job: job));
                        Get.snackbar("Job Clicked", job.title);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
