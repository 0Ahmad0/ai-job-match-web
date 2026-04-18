import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/job_model.dart';

class ApplyController extends GetxController {
  final selectedFileName = RxnString();
  final isUploading = false.obs;

  void setFileName(String? name) => selectedFileName.value = name;

  Future<void> submitApplication(JobModel job) async {
    if (selectedFileName.value == null) {
      Get.snackbar(
        'err_title'.tr,
        'lbl_select_cv'.tr,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isUploading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isUploading.value = false;
    Get.back(); // close sheet
    Get.snackbar(
      'success_title'.tr,
      'msg_app_sent'.tr,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
}
