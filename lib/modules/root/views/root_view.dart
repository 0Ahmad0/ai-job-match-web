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
      body: Obx(() {
        controller.tabsVersion.value;
        return controller.pages[controller.currentIndex.value];
      }),
      floatingActionButton: Obx(() {
        final showFab = controller.userRole.value == 'jobSeeker' &&
            controller.currentIndex.value == 0;
        if (!showFab) {
          return const SizedBox.shrink();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.theme.primaryColor.withValues(
                  alpha: controller.fabGlow.value ? 0.55 : 0.28,
                ),
                blurRadius: controller.fabGlow.value ? 28 : 12,
                spreadRadius: controller.fabGlow.value ? 7 : 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: controller.openPlatformChatbot,
            child: const Icon(Icons.smart_toy_outlined),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        controller.tabsVersion.value;
        return CurvedNavigationBar(
          index: controller.currentIndex.value,
          height: 60.h,
          items: controller.navItems,
          color: context.theme.primaryColor,
          buttonBackgroundColor: context.theme.primaryColor,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: controller.changePage,
          letIndexChange: (index) => true,
        );
      }),
    );
  }
}
