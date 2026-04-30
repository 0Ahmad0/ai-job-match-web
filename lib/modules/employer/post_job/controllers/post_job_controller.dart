import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/matcher_util.dart';
import '../../../../data/services/gemini_service.dart';

class PostJobController extends GetxController {
  final currentStep = 0.obs;

  final titleCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final minSalaryCtrl = TextEditingController();
  final maxSalaryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final skillInputCtrl = TextEditingController();

  final selectedJobType = 'Full Time'.obs;
  final jobTypes = ['Full Time', 'Part Time', 'Remote', 'Contract'];
  final requiredSkills = <String>[].obs;
  final aiRequirements = <String>[].obs;

  final isAiWriting = false.obs;
  final isPublishing = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GeminiService _geminiService;

  @override
  void onInit() {
    super.onInit();
    _geminiService = Get.isRegistered<GeminiService>()
        ? Get.find<GeminiService>()
        : Get.put(GeminiService(), permanent: true);
  }

  void nextStep() {
    if (currentStep.value == 0) {
      if (titleCtrl.text.trim().isEmpty || locationCtrl.text.trim().isEmpty) {
        Get.snackbar('err_title'.tr, 'err_fill_basic_details'.tr);
        return;
      }
      addSkillFromInput();
      if (requiredSkills.isEmpty) {
        final inferredSkills = _extractRequiredSkills(
          '${titleCtrl.text.trim()} ${descriptionCtrl.text.trim()}',
        );
        requiredSkills.assignAll(inferredSkills.take(5));
      }
      if (requiredSkills.isEmpty) {
        Get.snackbar('err_title'.tr, 'job_skills_min_error'.tr);
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

  void addSkillFromInput() {
    final raw = skillInputCtrl.text.trim();
    if (raw.isEmpty) {
      return;
    }
    final parts = raw
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    for (final part in parts) {
      _addSkill(part);
    }
    skillInputCtrl.clear();
  }

  void removeSkill(String skill) {
    requiredSkills.removeWhere((s) => s.toLowerCase() == skill.toLowerCase());
  }

  void _addSkill(String skill) {
    final clean = skill.trim();
    if (clean.isEmpty) {
      return;
    }
    final exists = requiredSkills.any(
      (s) => s.toLowerCase() == clean.toLowerCase(),
    );
    if (!exists) {
      requiredSkills.add(clean);
    }
  }

  Future<void> autoWriteDescription() async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar('err_title'.tr, 'err_enter_job_title'.tr);
      return;
    }

    isAiWriting.value = true;
    try {
      final draft = await _geminiService.generateJobDraft(
        jobTitle: titleCtrl.text.trim(),
        jobType: selectedJobType.value,
        location: locationCtrl.text.trim(),
        preferredSkills: requiredSkills,
        languageCode: Get.locale?.languageCode ?? 'en',
      );

      if (draft == null) {
        descriptionCtrl.text = 'msg_ai_job_desc_template'.trParams({
          'title': titleCtrl.text.trim(),
        });
        return;
      }

      final draftDescription = (draft['description'] as String?)?.trim() ?? '';
      final draftSkills = ((draft['required_skills'] as List?) ?? const [])
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final draftRequirements = ((draft['requirements'] as List?) ?? const [])
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (draftDescription.isNotEmpty) {
        descriptionCtrl.text = draftDescription;
      }

      for (final skill in draftSkills) {
        _addSkill(skill);
      }
      aiRequirements.assignAll(draftRequirements);
      Get.snackbar('success_title'.tr, 'job_ai_generated_success'.tr);
    } catch (e) {
      descriptionCtrl.text = 'msg_ai_job_desc_template'.trParams({
        'title': titleCtrl.text.trim(),
      });
      Get.snackbar('err_title'.tr, 'job_ai_generated_fallback'.tr);
    } finally {
      isAiWriting.value = false;
    }
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
      final companyDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      final companyName =
          (companyDoc.data()?['companyName'] as String?) ??
          user.displayName ??
          user.email ??
          'unknown_company'.tr;

      final extractedFromDescription = _extractRequiredSkills(
        descriptionCtrl.text,
      );
      final extractedFromTitle = _extractRequiredSkills(titleCtrl.text);
      final mergedSkills = <String>{
        ...requiredSkills,
        ...extractedFromTitle,
        ...extractedFromDescription,
      }.toList();
      final requirementsToSave = aiRequirements.isNotEmpty
          ? aiRequirements.toList()
          : _extractRequirements(descriptionCtrl.text, mergedSkills);

      await _firestore.collection('jobs').add({
        'title': titleCtrl.text.trim(),
        'company_name': companyName,
        'company_id': user.uid,
        'location': locationCtrl.text.trim(),
        'job_type': selectedJobType.value,
        'salary_min': int.tryParse(minSalaryCtrl.text.trim()) ?? 0,
        'salary_max': int.tryParse(maxSalaryCtrl.text.trim()) ?? 0,
        'description': descriptionCtrl.text.trim(),
        'required_skills': mergedSkills.take(20).toList(),
        'requirements': requirementsToSave.take(15).toList(),
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
    return MatcherUtil.extractKnownSkillsFromText(text).take(20).toList();
  }

  List<String> _extractRequirements(String description, List<String> skills) {
    final lines = description
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final bullets = lines
        .where((line) => line.startsWith('-') || line.startsWith('•'))
        .toList();
    final normalized = bullets
        .map((line) => line.replaceFirst(RegExp(r'^[-•]\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (normalized.isNotEmpty) {
      return normalized;
    }
    return skills
        .take(8)
        .map((s) => '${'job_requirement_with_skill'.trParams({'skill': s})}.')
        .toList();
  }

  void _clearForm() {
    titleCtrl.clear();
    locationCtrl.clear();
    minSalaryCtrl.clear();
    maxSalaryCtrl.clear();
    descriptionCtrl.clear();
    skillInputCtrl.clear();
    requiredSkills.clear();
    aiRequirements.clear();
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
    skillInputCtrl.dispose();
    super.onClose();
  }
}
