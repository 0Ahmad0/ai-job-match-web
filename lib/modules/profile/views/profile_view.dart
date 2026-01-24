import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/profile_controller.dart';
import 'sub_pages/about_view.dart';
import 'sub_pages/edit_profile_view.dart';
import 'sub_pages/faq_view.dart';
import 'sub_pages/notifications_view.dart';
import 'sub_pages/privacy_view.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/profile_stats_widget.dart';
import 'widgets/profile_menu_tile.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_title'.tr),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.verticalSpace,
            const ProfileHeaderWidget(),
            30.verticalSpace,
            const ProfileStatsWidget(),
            30.verticalSpace,

            // --- Account Settings ---
            _buildSectionHeader(context, 'sec_account'.tr),

            ProfileMenuTile(
              title: 'lbl_edit_profile'.tr,
              icon: Icons.person_outline,
              onTap: () {
                Get.to(() => const EditProfileView()); // ✅ تم الربط
              },
            ),
            ProfileMenuTile(
              title: 'lbl_notifications'.tr,
              icon: Icons.notifications_outlined,
              onTap: () {
                Get.to(() => const NotificationsView()); // ✅ تم الربط
              },
            ),
            ProfileMenuTile(
              title: 'lbl_edit_profile'.tr,
              icon: Icons.person_outline,
              onTap: () {
                Get.to(() => const EditProfileView()); // ✅ تم الربط
              },
            ),

            ProfileMenuTile(
              title: 'faq_title'.tr, // استخدمنا المفتاح الصحيح
              icon: Icons.question_answer_outlined,
              onTap: () {
                Get.to(() => const FaqView()); // ✅ تم الربط
              },
            ),
            ProfileMenuTile(
              title: 'about_title'.tr,
              icon: Icons.info_outline,
              onTap: () {
                Get.to(() => const AboutView()); // ✅ تم الربط
              },
            ),
            ProfileMenuTile(
              title: 'privacy_title'.tr,
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                Get.to(() => const PrivacyView()); // ✅ تم الربط
              },
            ),

            Divider(height: 30.h, thickness: 1, indent: 20, endIndent: 20),

            // --- App Settings ---
            _buildSectionHeader(context, 'sec_app_settings'.tr),

            // Language Toggle
            ProfileMenuTile(
              title: 'lbl_language'.tr,
              icon: Icons.language,
              trailing: Text(
                Get.locale?.languageCode == 'en' ? 'English' : 'العربية',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: controller.changeLanguage,
            ),

            // Theme Toggle
            GetBuilder<ProfileController>(
              // GetBuilder للتحديث عند تغيير الثيم
              builder: (_) => ProfileMenuTile(
                title: 'lbl_dark_mode'.tr,
                icon: Icons.dark_mode_outlined,
                trailing: Switch(
                  value: controller.isDarkMode,
                  activeColor: context.theme.primaryColor,
                  onChanged: controller.toggleTheme,
                ),
                onTap: () => controller.toggleTheme(!controller.isDarkMode),
              ),
            ),

            ProfileMenuTile(
              title: 'lbl_help'.tr,
              icon: Icons.help_outline,
              onTap: () {},
            ),

            20.verticalSpace,

            // --- Logout ---
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: ProfileMenuTile(
                title: 'lbl_logout'.tr,
                icon: Icons.logout,
                isDestructive: true,
                trailing: const SizedBox.shrink(),
                // إخفاء السهم
                onTap: controller.logout,
              ),
            ),

            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
