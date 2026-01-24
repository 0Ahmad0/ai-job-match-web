import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostJobController extends GetxController {
  final currentStep = 0.obs;

  // Controllers
  final titleCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final minSalaryCtrl = TextEditingController();
  final maxSalaryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  // Dropdown Values
  final selectedJobType = 'Full Time'.obs;
  final jobTypes = ['Full Time', 'Part Time', 'Remote', 'Contract'];

  // AI Loading State
  final isAiWriting = false.obs;

  void nextStep() {
    if (currentStep.value == 0) {
      if (titleCtrl.text.isEmpty || locationCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Please fill basic details');
        return;
      }
      currentStep.value = 1;
    } else {
      // Publish Logic
      publishJob();
    }
  }

  void prevStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  // الميزة الخرافية: الكتابة التلقائية
  void autoWriteDescription() async {
    if (titleCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Enter Job Title first');
      return;
    }

    isAiWriting.value = true;

    // محاكاة تأخير الـ API
    await Future.delayed(const Duration(seconds: 2));

    // نص جاهز حسب العنوان (سيناريو وهمي)
    descriptionCtrl.text =
        """
We are looking for a skilled ${titleCtrl.text} to join our team.

Responsibilities:
• Develop and maintain clean code.
• Collaborate with cross-functional teams.
• Troubleshoot and debug applications.

Requirements:
• 3+ years of experience.
• Strong problem-solving skills.
• Experience with Agile methodologies.
""";

    isAiWriting.value = false;
  }

  void publishJob() {
    Get.snackbar(
      'Success',
      'msg_job_published'.tr,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // Reset
    titleCtrl.clear();
    descriptionCtrl.clear();
    currentStep.value = 0;
  }
}
