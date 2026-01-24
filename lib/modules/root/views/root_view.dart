import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الجسم: الصفحة المختارة حالياً
      body: Obx(() => controller.pages[controller.currentIndex.value]),

      // البار السفلي
      bottomNavigationBar: Obx(() => CurvedNavigationBar(
        index: controller.currentIndex.value,
        height: 60.h,
        items: controller.navItems,
        color: context.theme.primaryColor,
        buttonBackgroundColor: context.theme.primaryColor,
        backgroundColor: Colors.transparent, // مهم جداً لشفافية الخلفية
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: controller.changePage,
        letIndexChange: (index) => true,
      )),
    );
  }
}