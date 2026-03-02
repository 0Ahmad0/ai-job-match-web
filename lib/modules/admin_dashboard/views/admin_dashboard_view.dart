import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/admin_dashboard_controller.dart';
import 'widgets/admin_stat_card.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // التأكد من حقن الكنترولر
    Get.put(AdminDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'admin_dash_title'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان ترحيبي (اختياري لملء الفراغ)
            Text("Overview", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            15.verticalSpace,

            // Stats Grid
            // نستخدم Obx لمراقبة التغييرات في العدادات
            Obx(() => GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 1.4,
              children: [
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: AdminStatCard(
                    title: 'lbl_total_users'.tr,
                    // نستخدم usersList.length كمثال حي، أو totalUsers إذا كانت مفصولة
                    value: controller.usersList.length.toString(),
                    icon: FontAwesomeIcons.users,
                    color: Colors.blue,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: AdminStatCard(
                    title: 'lbl_pending_companies'.tr,
                    // نحسب عدد الشركات المعلقة
                    value: controller.usersList.where((u) => u['status'] == 'Pending').length.toString(),
                    icon: FontAwesomeIcons.hourglassHalf,
                    color: Colors.orange,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: AdminStatCard(
                    title: 'lbl_admin_jobs'.tr, // الوظائف المعلقة
                    value: controller.jobRequests.length.toString(),
                    icon: FontAwesomeIcons.briefcase, // أيقونة أنسب
                    color: Colors.purple,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: AdminStatCard(
                    title: 'lbl_revenue'.tr,
                    value: '\$12k',
                    icon: FontAwesomeIcons.moneyBillWave,
                    color: Colors.green,
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}