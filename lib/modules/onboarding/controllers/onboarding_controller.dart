import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/onboarding_model.dart';
// import '../../../routes/app_routes.dart'; // سنحتاجه للانتقال

class OnboardingController extends GetxController {
  var pageController = PageController();
  var currentPage = 0.obs;

  // قائمة البيانات (يفضل استخدام Lottie Files لجمال أكثر)
  // سأستخدم أيقونات كمثال، يمكنك استبدالها بمسارات 'assets/animations/job.json'
  final List<OnboardingModel> pages = [
    OnboardingModel(
      image: 'assets/animations/onboarding_1.json', // استبدلها بملفاتك
      title: 'onb_title_1',
      description: 'onb_desc_1',
    ),
    OnboardingModel(
      image: 'assets/animations/onboarding_2.json',
      title: 'onb_title_2',
      description: 'onb_desc_2',
    ),
    OnboardingModel(
      image: 'assets/animations/onboarding_3.json',
      title: 'onb_title_3',
      description: 'onb_desc_3',
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value == pages.length - 1) {
      _finishOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 600), // حركة أبطأ قليلاً لتكون أنعم
        curve: Curves.easeInOutCubic, // انميشن جذاب
      );
    }
  }

  void _finishOnboarding() {
    // حفظ في التخزين أن المستخدم تخطى البداية
    // Get.find<StorageService>().saveOnboardingSeen();

    // الانتقال للوجين
    Get.offAllNamed(Routes.AUTH_LOGIN);
    print("Go to Login/Home");
  }
}