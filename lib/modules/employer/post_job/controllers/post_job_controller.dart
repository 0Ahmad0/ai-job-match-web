import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostJobController extends GetxController {
  final currentStep = 0.obs;

  final titleCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final minSalaryCtrl = TextEditingController();
  final maxSalaryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  final selectedJobType = 'Full Time'.obs;
  final jobTypes = ['Full Time', 'Part Time', 'Remote', 'Contract'];

  final isAiWriting = false.obs;
  final isPublishing = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void nextStep() {
    if (currentStep.value == 0) {
      if (titleCtrl.text.isEmpty || locationCtrl.text.isEmpty) {
        Get.snackbar('err_title'.tr, 'err_fill_basic_details'.tr);
        return;
      }
      currentStep.value = 1;
      return;
    }

    publishJob();
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> autoWriteDescription() async {
    if (titleCtrl.text.isEmpty) {
      Get.snackbar('err_title'.tr, 'err_enter_job_title'.tr);
      return;
    }

    isAiWriting.value = true;
    await Future.delayed(const Duration(seconds: 2));
    descriptionCtrl.text = 'msg_ai_job_desc_template'.trParams({
      'title': titleCtrl.text,
    });
    isAiWriting.value = false;
  }

  Future<void> publishJob() async {
    if (isPublishing.value) {
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('err_title'.tr, 'auth_err_no_user_logged_in'.tr);
      return;
    }

    isPublishing.value = true;
    try {
      final companyDoc = await _firestore.collection('users').doc(user.uid).get();
      final companyName = (companyDoc.data()?['companyName'] as String?) ??
          user.displayName ??
          user.email ??
          'unknown_company'.tr;

      final requiredSkills = _extractRequiredSkills(descriptionCtrl.text);

      await _firestore.collection('jobs').add({
        'title': titleCtrl.text.trim(),
        'company_name': companyName,
        'company_id': user.uid,
        'location': locationCtrl.text.trim(),
        'job_type': selectedJobType.value,
        'salary_min': int.tryParse(minSalaryCtrl.text.trim()) ?? 0,
        'salary_max': int.tryParse(maxSalaryCtrl.text.trim()) ?? 0,
        'description': descriptionCtrl.text.trim(),
        'required_skills': requiredSkills,
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'success_title'.tr,
        'msg_job_published'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _clearForm();
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'err_job_publish_failed'.trParams({'error': e.toString()}),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPublishing.value = false;
    }
  }

  List<String> _extractRequiredSkills(String text) {
    final lines = text.split('\n');
    final skills = <String>{};

    for (final raw in lines) {
      final line = raw.trim();
      if (line.startsWith('-')) {
        final skill = line.replaceFirst('-', '').trim();
        if (skill.isNotEmpty) {
          skills.add(skill);
        }
      }
    }

    if (skills.isEmpty) {
      final words = titleCtrl.text
          .toLowerCase()
          .split(RegExp(r'[^a-zA-Z]+'))
          .where((w) => w.length > 2)
          .toSet()
          .toList();
      skills.addAll(words.take(5));
    }

    return skills.take(15).toList();
  }

  void _clearForm() {
    titleCtrl.clear();
    locationCtrl.clear();
    minSalaryCtrl.clear();
    maxSalaryCtrl.clear();
    descriptionCtrl.clear();
    selectedJobType.value = jobTypes.first;
    currentStep.value = 0;
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    locationCtrl.dispose();
    minSalaryCtrl.dispose();
    maxSalaryCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
