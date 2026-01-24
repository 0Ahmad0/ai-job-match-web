import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../jobs/views/job_details_view.dart';
import '../controllers/seeker_home_controller.dart';
// ✅ استيراد موديل وظائف والكنترولر والويدجت
import '../../jobs/controllers/jobs_controller.dart';
import '../../jobs/views/widgets/job_card_widget.dart';
import '../../jobs/views/jobs_view.dart'; // للانتقال
import 'widgets/home_header_widget.dart';
import 'widgets/action_card_widget.dart';

class SeekerHomeView extends GetView<SeekerHomeController> {
  const SeekerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ نحقن كنترولر الوظائف للوصول للبيانات
    final jobsController = Get.put(JobsController());

    return Scaffold(
      body: Column(
        children: [
          const HomeHeaderWidget(),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... (الأقسام السابقة: العنوان والبطاقات كما هي) ...
                  FadeInLeft(child: Text('Start Your Journey', style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp))),
                  20.verticalSpace,
                  // البطاقات (Upload/Create) ... (الكود القديم موجود هنا)
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: ActionCardWidget(
                      title: 'card_upload_title'.tr,
                      description: 'card_upload_desc'.tr,
                      icon: FontAwesomeIcons.filePdf,
                      color: Colors.orange,
                      onTap: controller.onUploadCvTap,
                    ),
                  ),
                  20.verticalSpace,
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: ActionCardWidget(
                      title: 'card_create_title'.tr,
                      description: 'card_create_desc'.tr,
                      icon: FontAwesomeIcons.penNib,
                      color: Colors.purple,
                      onTap: controller.onCreateCvTap,
                    ),
                  ),

                  30.verticalSpace,

                  // ✅ قسم الوظائف الجديد
                  FadeInLeft(
                    delay: const Duration(milliseconds: 600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('recommended_jobs'.tr, style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp)),

                        // زر View All
                        TextButton(
                          onPressed: () {
                            // الانتقال لصفحة الوظائف الكاملة
                            Get.to(() => const JobsView());
                          },
                          child: Text('view_all'.tr, style: TextStyle(color: context.theme.primaryColor, fontSize: 12.sp)),
                        ),
                      ],
                    ),
                  ),

                  15.verticalSpace,

                  // ✅ عرض أول 3 وظائف فقط
                  Obx(() {
                    // نأخذ أول 3 عناصر فقط للعرض في الرئيسية
                    final jobsToShow = jobsController.allJobs.take(3).toList();

                    return Column(
                      children: jobsToShow.map((job) => JobCardWidget(
                        job: job,
                        onTap: () {
                          Get.to(() => JobDetailsView(job: job));
                          Get.snackbar("Job", job.title);
                        },
                      )).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}