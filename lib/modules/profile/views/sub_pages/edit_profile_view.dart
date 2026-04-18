import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/app_ui.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_text_field.dart';
import '../../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lbl_edit_profile'.tr),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: AppPageContainer(
            maxWidth: 760,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: 'lbl_edit_profile'.tr,
                  subtitle: 'profile_edit_subtitle'.tr,
                ),
                24.verticalSpace,
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          AppUserAvatar(
                            name: controller.userName.value,
                            imageUrl: controller.userImage.value,
                            radius: 46,
                          ),
                          PositionedDirectional(
                            bottom: 0,
                            end: 0,
                            child: Material(
                              color: context.theme.primaryColor,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: controller.pickProfileImage,
                                child: Padding(
                                  padding: EdgeInsets.all(10.r),
                                  child: controller.isUploadingImage.value
                                      ? SizedBox(
                                          width: 18.w,
                                          height: 18.w,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      Text(
                        'profile_image_hint'.tr,
                        style: context.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                28.verticalSpace,
                CustomTextField(
                  label: 'lbl_fullname'.tr,
                  hint: 'name_hint'.tr,
                  prefixIcon: Icons.person_outline,
                  controller: controller.editNameCtrl,
                ),
                18.verticalSpace,
                CustomTextField(
                  label: 'lbl_job_title'.tr,
                  hint: 'profile_headline_hint'.tr,
                  prefixIcon: Icons.work_outline,
                  controller: controller.editJobCtrl,
                ),
                18.verticalSpace,
                CustomTextField(
                  label: 'lbl_bio'.tr,
                  hint: 'hint_about_yourself'.tr,
                  prefixIcon: Icons.notes_outlined,
                  controller: controller.editBioCtrl,
                  maxLines: 5,
                ),
                28.verticalSpace,
                controller.isSaving.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'lbl_save_changes'.tr,
                        onPressed: controller.saveProfileChanges,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
