import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            // صورة البروفايل مع زر تعديل
            Stack(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.person, size: 50.sp, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18.r,
                    backgroundColor: context.theme.primaryColor,
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
                  ),
                )
              ],
            ),
            40.verticalSpace,

            CustomTextField(
              label: 'lbl_fullname'.tr, // استخدمنا مفتاح موجود سابقاً
              hint: '',
              prefixIcon: Icons.person_outline,
              controller: controller.editNameCtrl,
            ),
            20.verticalSpace,
            CustomTextField(
              label: 'lbl_job_title'.tr, // استخدمنا مفتاح موجود سابقاً
              hint: '',
              prefixIcon: Icons.work_outline,
              controller: controller.editJobCtrl,
            ),
            20.verticalSpace,
            // Bio Field (Custom design for multiline)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('lbl_bio'.tr, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                8.verticalSpace,
                TextField(
                  controller: controller.editBioCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Write about yourself...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    filled: true,
                    fillColor: context.isDarkMode ? Colors.white10 : Colors.grey.shade100,
                  ),
                ),
              ],
            ),

            50.verticalSpace,

            CustomButton(
              text: 'lbl_save_changes'.tr,
              onPressed: controller.saveProfileChanges,
            ),
          ],
        ),
      ),
    );
  }
}