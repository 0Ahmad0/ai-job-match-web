import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart'; // تأكد من المسار
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  // للوصول لكنترولر الثيم العام الذي أنشأناه في البداية
  final ThemeController _themeController = Get.find();
  late TextEditingController editNameCtrl;
  late TextEditingController editJobCtrl;
  late TextEditingController editBioCtrl;

  // بيانات وهمية للمستخدم
  final userName = "Ahmed Ali".obs;
  final userJob = "Senior Flutter Developer".obs;
  final userImage = "".obs; // لو فارغة سنعرض أيقونة

  // الإحصائيات الوهمية
  final statApplied = 12.obs;
  final statReviewed = 45.obs;
  final statInterviews = 3.obs;

  // حالة الثيم (نربطها بالكنترولر الأساسي)
  bool get isDarkMode => _themeController.isDarkMode;

  void toggleTheme(bool value) {
    _themeController.toggleTheme();
    update(); // لتحديث الواجهة فوراً
  }

  void changeLanguage() {
    // تبديل بسيط بين العربية والانجليزية
    if (Get.locale?.languageCode == 'en') {
      Get.updateLocale(const Locale('ar', 'SA'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  void logout() {
    Get.defaultDialog(
      title: 'lbl_logout'.tr,
      middleText: 'msg_logout_confirm'.tr,
      textConfirm: 'btn_yes_logout'.tr,
      textCancel: 'btn_cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // هنا نقوم بمسح التوكن من التخزين
        // StorageService.box.remove('token');

        Get.back(); // إغلاق الديالوج
        Get.offAllNamed(Routes.AUTH_LOGIN); // العودة للوجين
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    // تهيئة المتحكمات بالبيانات الحالية
    editNameCtrl = TextEditingController(text: userName.value);
    editJobCtrl = TextEditingController(text: userJob.value);
    editBioCtrl = TextEditingController(
      text: "Senior Flutter Developer with 5 years of experience...",
    );
  }

  void saveProfileChanges() {
    if (editNameCtrl.text.isNotEmpty) {
      userName.value = editNameCtrl.text;
      userJob.value = editJobCtrl.text;

      Get.back(); // العودة للبروفايل
      Get.snackbar(
        'success_title'.tr,
        'msg_profile_updated'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    }
  }

  @override
  void onClose() {
    editNameCtrl.dispose();
    editJobCtrl.dispose();
    editBioCtrl.dispose();
    super.onClose();
  }
}
