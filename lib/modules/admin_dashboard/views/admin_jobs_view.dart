import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminJobsView extends GetView<AdminDashboardController> {
  const AdminJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lbl_admin_jobs'.tr), centerTitle: true),
      body: Obx(() {
        if (controller.jobRequests.isEmpty) {
          return const Center(child: Text("No Pending Jobs"));
        }
        return ListView.builder(
          padding: EdgeInsets.all(20.r),
          itemCount: controller.jobRequests.length,
          itemBuilder: (context, index) {
            final job = controller.jobRequests[index];
            return Card(
              margin: EdgeInsets.only(bottom: 15.h),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.work, color: Colors.blue),
                        10.horizontalSpace,
                        Text(job['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      ],
                    ),
                    5.verticalSpace,
                    Text("Company: ${job['company']} • Salary: ${job['salary']}", style: const TextStyle(color: Colors.grey)),
                    10.verticalSpace,
                    Container(
                      padding: EdgeInsets.all(10.r),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(job['desc'], style: TextStyle(fontSize: 12.sp)),
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => controller.rejectJob(job['id']),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                          child: Text('btn_reject'.tr),
                        ),
                        10.horizontalSpace,
                        ElevatedButton(
                          onPressed: () => controller.approveJob(job['id']),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: Text('btn_approve'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}