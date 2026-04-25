import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/app_ui.dart';
import '../../../core/common/shimmer_skeletons.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_stats_widget.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_title'.tr),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    ProfileHeaderShimmer(),
                    SizedBox(height: 24),
                    CardListShimmer(itemCount: 3),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: AppPageContainer(
                  maxWidth: 960,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      12.verticalSpace,
                      const ProfileHeaderWidget(),
                      28.verticalSpace,
                      const Center(child: ProfileStatsWidget()),
                      28.verticalSpace,
                      _buildSectionHeader(context, 'sec_account'.tr),
                      ProfileMenuTile(
                        title: 'lbl_edit_profile'.tr,
                        icon: Icons.person_outline,
                        onTap: () => Get.toNamed(Routes.PROFILE_EDIT),
                      ),
                      ProfileMenuTile(
                        title: 'lbl_notifications'.tr,
                        icon: Icons.notifications_outlined,
                        onTap: () => Get.toNamed(Routes.PROFILE_NOTIFICATIONS),
                      ),
                      ProfileMenuTile(
                        title: 'faq_title'.tr,
                        icon: Icons.question_answer_outlined,
                        onTap: () => Get.toNamed(Routes.PROFILE_FAQ),
                      ),
                      ProfileMenuTile(
                        title: 'privacy_title'.tr,
                        icon: Icons.privacy_tip_outlined,
                        onTap: () => Get.toNamed(Routes.PROFILE_PRIVACY),
                      ),
                      ProfileMenuTile(
                        title: 'terms_title'.tr,
                        icon: Icons.gavel_outlined,
                        onTap: () => Get.toNamed(Routes.PROFILE_TERMS),
                      ),
                      ProfileMenuTile(
                        title: 'contact_us_title'.tr,
                        icon: Icons.mail_outline,
                        onTap: () => Get.toNamed(Routes.PROFILE_CONTACT),
                      ),
                      ProfileMenuTile(
                        title: 'support_title'.tr,
                        icon: Icons.support_agent_outlined,
                        onTap: () => Get.toNamed(Routes.PROFILE_SUPPORT),
                      ),
                      ProfileMenuTile(
                        title: 'about_title'.tr,
                        icon: Icons.info_outline,
                        onTap: () => Get.toNamed(Routes.PROFILE_ABOUT),
                      ),
                      Divider(height: 34.h, thickness: 1),
                      _buildSectionHeader(context, 'sec_app_settings'.tr),
                      ProfileMenuTile(
                        title: 'lbl_language'.tr,
                        icon: Icons.language,
                        trailing: Text(
                          Get.locale?.languageCode == 'en'
                              ? 'language_english'.tr
                              : 'language_arabic'.tr,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: controller.changeLanguage,
                      ),
                      GetBuilder<ProfileController>(
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
                      16.verticalSpace,
                      FadeInUp(
                        delay: const Duration(milliseconds: 180),
                        child: ProfileMenuTile(
                          title: 'delete_account_title'.tr,
                          icon: Icons.delete_outline,
                          isDestructive: true,
                          trailing: const SizedBox.shrink(),
                          onTap: controller.confirmDeleteAccount,
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 260),
                        child: ProfileMenuTile(
                          title: 'lbl_logout'.tr,
                          icon: Icons.logout,
                          isDestructive: true,
                          trailing: const SizedBox.shrink(),
                          onTap: controller.logout,
                        ),
                      ),
                      34.verticalSpace,
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }
}
