import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/cv_model.dart';
import '../../../data/services/gemini_service.dart';
import '../../../data/services/pdf_service.dart';
import '../views/cv_preview_view.dart';

class CvBuilderController extends GetxController {
  final currentStep = 0.obs;
  final totalSteps = 7;
  final cvData = CvModel();
  final selectedTemplate = 1.obs;
  final isLoading = true.obs;
  final isSaving = false.obs;
  final isAnalyzing = false.obs;
  final highlightedSections = RxSet<String>();
  final aiSuggestions = <String>[].obs;
  final atsScore = 0.obs;
  final detectedCvLanguage = 'en'.obs;
  final generatedPdfBytes = Rxn<Uint8List>();
  final generatedPdfFileName = 'My_Professional_CV.pdf'.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GeminiService _geminiService = Get.find<GeminiService>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();
  final summaryCtrl = TextEditingController();

  final jobTitleCtrl = TextEditingController();
  final expJobTitleCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final expStartCtrl = TextEditingController();
  final expEndCtrl = TextEditingController();
  final expDescCtrl = TextEditingController();

  final schoolCtrl = TextEditingController();
  final degreeCtrl = TextEditingController();
  final eduYearCtrl = TextEditingController();

  final skillCtrl = TextEditingController();
  final selectedSkillLevel = 1.obs;

  final projectNameCtrl = TextEditingController();
  final projectDescCtrl = TextEditingController();
  final projectYearCtrl = TextEditingController();
  final projectUrlCtrl = TextEditingController();

  final experiences = <CvExperience>[].obs;
  final educations = <CvEducation>[].obs;
  final skillsList = <CvSkill>[].obs;
  final projects = <CvProject>[].obs;
  
  static const Map<String, int> sectionStepMap = {
    'personal': 0,
    'summary': 1,
    'experience': 2,
    'education': 3,
    'skills': 4,
    'projects': 5,
    'template': 6,
  };

  @override
  void onInit() {
    super.onInit();
    loadDraft();
  }

  Future<void> loadDraft() async {
    final user = _auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? const <String, dynamic>{};
      final args = Get.arguments is Map<String, dynamic> ? Get.arguments as Map<String, dynamic> : const <String, dynamic>{};
      final isNew = (args['isNew'] as bool?) ?? false;
      final fixPayload = (args['fixPayload'] as Map<String, dynamic>?) ?? const <String, dynamic>{};

      // If creating new CV, prefill with account/profile data
      if (isNew) {
        _prefillFromAccountData(data, user);
      } else {
        // Load existing draft
        final manualCv = (data['manual_cv'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
        _loadFromManualCv(manualCv, data, user);
      }

      if (fixPayload.isNotEmpty) {
        _applyFixPayload(fixPayload);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _prefillFromAccountData(Map<String, dynamic> userData, User user) {
    // Clear all fields for new CV
    nameCtrl.text = (userData['fullName'] as String?) ?? user.displayName ?? '';
    emailCtrl.text = (userData['email'] as String?) ?? (user.email ?? '');
    phoneCtrl.text = (userData['phone'] as String?) ?? '';
    addressCtrl.text = (userData['address'] as String?) ?? '';
    linkedinCtrl.text = (userData['linkedin'] as String?) ?? '';
    summaryCtrl.text = (userData['bio'] as String?) ?? '';

    // Clear lists for new CV
    experiences.clear();
    educations.clear();
    skillsList.clear();
    projects.clear();

    // Prefill skills from AI extracted skills if available
    final aiSkills = ((userData['ai_extracted_skills'] as List?) ?? const [])
        .map((e) => CvSkill(name: e.toString(), level: 3))
        .toList();
    if (aiSkills.isNotEmpty) {
      skillsList.assignAll(aiSkills);
    }
  }

  void _loadFromManualCv(Map<String, dynamic> manualCv, Map<String, dynamic> userData, User user) {
    nameCtrl.text = (manualCv['fullName'] as String?) ?? (userData['fullName'] as String?) ?? '';
    emailCtrl.text = (manualCv['email'] as String?) ?? (userData['email'] as String?) ?? (user.email ?? '');
    phoneCtrl.text = (manualCv['phone'] as String?) ?? (userData['phone'] as String?) ?? '';
    addressCtrl.text = (manualCv['address'] as String?) ?? (userData['address'] as String?) ?? '';
    linkedinCtrl.text = (manualCv['linkedin'] as String?) ?? (userData['linkedin'] as String?) ?? '';
    summaryCtrl.text = (manualCv['summary'] as String?) ?? (userData['bio'] as String?) ?? '';

    experiences.assignAll(_mapExperiences((manualCv['experience'] as List?) ?? const []));
    educations.assignAll(_mapEducations((manualCv['education'] as List?) ?? const []));
    skillsList.assignAll(_mapSkills((manualCv['skills'] as List?) ?? const []));
    projects.assignAll(_mapProjects((manualCv['projects'] as List?) ?? const []));
    selectedTemplate.value = (manualCv['selectedTemplate'] as int?) ?? 1;

    if (skillsList.isEmpty) {
      final aiSkills = ((userData['ai_extracted_skills'] as List?) ?? const [])
          .map((e) => CvSkill(name: e.toString(), level: 3))
          .toList();
      skillsList.assignAll(aiSkills);
    }
  }

  void _applyFixPayload(Map<String, dynamic> payload) {
    aiSuggestions.assignAll(((payload['suggestions'] as List?) ?? const []).map((e) => e.toString()));
    detectedCvLanguage.value = (payload['language'] as String?) ?? 'en';

    final extractedTitle = (payload['jobTitle'] as String?) ?? '';
    if (editingHeadline.isEmpty && extractedTitle.isNotEmpty) {
      editJobTitle(extractedTitle);
    }

    final extractedSkills = ((payload['skills'] as List?) ?? const []).map((e) => e.toString()).toList();
    for (final skill in extractedSkills) {
      if (skillsList.every((existing) => existing.name.toLowerCase() != skill.toLowerCase())) {
        skillsList.add(CvSkill(name: skill, level: 3));
      }
    }

    for (final suggestion in aiSuggestions) {
      final lower = suggestion.toLowerCase();
      if (lower.contains('summary') || lower.contains('profile')) {
        highlightedSections.add('summary');
      }
      if (lower.contains('skill')) {
        highlightedSections.add('skills');
      }
      if (lower.contains('experience')) {
        highlightedSections.add('experience');
      }
      if (lower.contains('education')) {
        highlightedSections.add('education');
      }
      if (lower.contains('project')) {
        highlightedSections.add('projects');
      }
    }

    _moveToFirstHighlightedStep();
  }

  bool isSectionHighlighted(String key) => highlightedSections.contains(key);
  bool get isRefactorMode => aiSuggestions.isNotEmpty || highlightedSections.isNotEmpty;
  String get flowModeTitle => isRefactorMode ? 'flow_mode_refactor'.tr : 'flow_mode_create'.tr;
  String get flowModeSubtitle => isRefactorMode
      ? 'flow_mode_refactor_subtitle'.tr
      : 'flow_mode_create_subtitle'.tr;
  List<String> get orderedHighlightedSections => highlightedSections.toList()
    ..sort((a, b) => (sectionStepMap[a] ?? 999).compareTo(sectionStepMap[b] ?? 999));

  String get editingHeadline => jobTitleCtrl.text.trim().isNotEmpty ? jobTitleCtrl.text.trim() : summaryCtrl.text.trim();

  void editJobTitle(String value) {
    if (jobTitleCtrl.text.trim().isEmpty) {
      jobTitleCtrl.text = value;
    }
  }

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  void selectTemplate(int index) => selectedTemplate.value = index;
  void jumpToStep(int step) {
    if (step < 0 || step >= totalSteps) return;
    currentStep.value = step;
  }

  int? jumpToSection(String sectionKey) {
    final targetStep = sectionStepMap[sectionKey];
    if (targetStep == null) return null;
    jumpToStep(targetStep);
    return targetStep;
  }

  void addExperience() {
    if (expJobTitleCtrl.text.trim().isNotEmpty) {
      experiences.add(
        CvExperience(
          jobTitle: expJobTitleCtrl.text.trim(),
          company: companyCtrl.text.trim(),
          startDate: expStartCtrl.text.trim(),
          endDate: expEndCtrl.text.trim(),
          description: expDescCtrl.text.trim(),
        ),
      );
      experiences.refresh();
      highlightedSections.remove('experience');
      _clearExpFields();
      Get.back();
      Get.snackbar('success_title'.tr, 'msg_exp_added'.tr, backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('err_title'.tr, 'err_job_title_required'.tr, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void removeExperience(int index) => experiences.removeAt(index);

  void _clearExpFields() {
    expJobTitleCtrl.clear();
    companyCtrl.clear();
    expStartCtrl.clear();
    expEndCtrl.clear();
    expDescCtrl.clear();
  }

  void addEducation() {
    if (schoolCtrl.text.isNotEmpty) {
      educations.add(CvEducation(school: schoolCtrl.text, degree: degreeCtrl.text, year: eduYearCtrl.text));
      highlightedSections.remove('education');
      _clearEduFields();
      Get.back();
      update();
    }
  }

  void removeEducation(int index) => educations.removeAt(index);

  void _clearEduFields() {
    schoolCtrl.clear();
    degreeCtrl.clear();
    eduYearCtrl.clear();
  }

  void addSkill() {
    if (skillCtrl.text.isNotEmpty) {
      skillsList.add(CvSkill(name: skillCtrl.text, level: selectedSkillLevel.value));
      skillCtrl.clear();
      highlightedSections.remove('skills');
      update();
    }
  }

  void removeSkill(CvSkill skill) => skillsList.remove(skill);

  Future<void> saveDraft() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      isSaving.value = true;
      await _firestore.collection('users').doc(user.uid).set({
        'manual_cv': _buildManualCvPayload(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      Get.snackbar('success_title'.tr, 'cv_saved_draft'.tr);
    } catch (e) {
      Get.snackbar('err_title'.tr, 'cv_save_error'.trParams({'error': e.toString()}));
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> previewPdf() async {
    _populateCvData();

    if (cvData.fullName.isEmpty) {
      highlightedSections.add('personal');
      Get.snackbar('err_title'.tr, 'err_name_required'.tr);
      return;
    }

    try {
      isSaving.value = true;
      await saveDraft();
      final languageCode = (Get.locale?.languageCode ?? detectedCvLanguage.value).toLowerCase();
      final fileName = _buildPdfFileName(cvData.fullName);
      final bytes = await PdfService().generateCVBytes(
        cvData,
        selectedTemplate.value,
        languageCode: languageCode,
      );
      generatedPdfBytes.value = bytes;
      generatedPdfFileName.value = fileName;
      await Get.to(() => const CvPreviewView());
    } catch (e) {
      Get.snackbar('err_title'.tr, 'err_generate_pdf'.trParams({'error': e.toString()}));
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> generatePdf() async {
    await previewPdf();
  }

  Future<void> openGeneratedPdf() async {
    final bytes = generatedPdfBytes.value;
    if (bytes == null) {
      Get.snackbar('err_title'.tr, 'cv_no_pdf_generated'.tr);
      return;
    }

    try {
      await PdfService().openPdfBytes(bytes, fileName: generatedPdfFileName.value);
    } catch (e) {
      Get.snackbar('err_title'.tr, 'err_generate_pdf'.trParams({'error': e.toString()}));
    }
  }

  Future<void> downloadGeneratedPdf() async {
    final bytes = generatedPdfBytes.value;
    if (bytes == null) {
      Get.snackbar('err_title'.tr, 'cv_no_pdf_generated'.tr);
      return;
    }

    try {
      final savedPath = await PdfService().savePdfToDevice(
        bytes,
        fileName: generatedPdfFileName.value,
      );
      Get.snackbar(
        'success_title'.tr,
        'cv_download_success'.trParams({'path': savedPath}),
      );
    } catch (e) {
      Get.snackbar(
        'err_title'.tr,
        'cv_download_error'.trParams({'error': e.toString()}),
      );
    }
  }

  Future<void> shareGeneratedPdf() async {
    final bytes = generatedPdfBytes.value;
    if (bytes == null) {
      Get.snackbar('err_title'.tr, 'cv_no_pdf_generated'.tr);
      return;
    }

    try {
      await PdfService().sharePdfBytes(
        bytes,
        fileName: generatedPdfFileName.value,
      );
    } catch (e) {
      Get.snackbar('err_title'.tr, 'cv_download_error'.trParams({'error': e.toString()}));
    }
  }

  void addProject() {
    if (projectNameCtrl.text.isNotEmpty) {
      projects.add(CvProject(name: projectNameCtrl.text, description: projectDescCtrl.text, year: projectYearCtrl.text, url: projectUrlCtrl.text));
      highlightedSections.remove('projects');
      _clearProjectFields();
      Get.back();
    }
  }

  void _clearProjectFields() {
    projectNameCtrl.clear();
    projectDescCtrl.clear();
    projectYearCtrl.clear();
    projectUrlCtrl.clear();
  }

  Future<void> optimizeWithAi() async {
    _populateCvData();
    
    if (cvData.fullName.isEmpty) {
      Get.snackbar('err_title'.tr, 'err_name_required'.tr);
      return;
    }

    try {
      isAnalyzing.value = true;
      final analysis = await _geminiService.analyzeCvModel(cvData);
      
      if (analysis != null) {
        final suggestions = ((analysis['suggestions_for_improvement'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList();
        
        aiSuggestions.assignAll(suggestions);
        atsScore.value = (analysis['ats_score'] as num?)?.toInt() ?? 0;
        detectedCvLanguage.value = (analysis['cv_language'] as String?) ?? 'en';
        
        highlightedSections.clear();
        for (final suggestion in aiSuggestions) {
          final lower = suggestion.toLowerCase();
          if (lower.contains('summary') || lower.contains('profile')) {
            highlightedSections.add('summary');
          }
          if (lower.contains('skill')) {
            highlightedSections.add('skills');
          }
          if (lower.contains('experience')) {
            highlightedSections.add('experience');
          }
          if (lower.contains('education')) {
            highlightedSections.add('education');
          }
          if (lower.contains('project')) {
            highlightedSections.add('projects');
          }
        }

        Get.snackbar(
          'tip_ai_suggestion_title'.tr,
          'msg_ai_optimization_complete'.trParams({'score': atsScore.value.toString()}),
          backgroundColor: Colors.blue.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.snackbar('err_title'.tr, 'err_cv_analysis_failed'.tr);
    } finally {
      isAnalyzing.value = false;
    }
  }

  void _moveToFirstHighlightedStep() {
    if (highlightedSections.isEmpty) return;
    final firstSection = orderedHighlightedSections.first;
    jumpToSection(firstSection);
  }

  void _populateCvData() {
    cvData.fullName = nameCtrl.text.trim();
    cvData.email = emailCtrl.text.trim();
    cvData.phone = phoneCtrl.text.trim();
    cvData.address = addressCtrl.text.trim();
    cvData.linkedin = linkedinCtrl.text.trim();
    cvData.summary = summaryCtrl.text.trim();
    cvData.jobTitle = jobTitleCtrl.text.trim();
    cvData.experience = experiences.toList();
    cvData.education = educations.toList();
    cvData.skills = skillsList.toList();
    cvData.projects = projects.toList();
  }

  String _buildPdfFileName(String fullName) {
    final trimmed = fullName.trim();
    final safeName = trimmed
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
    final normalized = safeName.isEmpty ? 'My_Professional_CV' : safeName;
    return '${normalized}_CV.pdf';
  }

  Map<String, dynamic> _buildManualCvPayload() {
    return {
      'fullName': nameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'address': addressCtrl.text.trim(),
      'linkedin': linkedinCtrl.text.trim(),
      'summary': summaryCtrl.text.trim(),
      'jobTitle': jobTitleCtrl.text.trim(),
      'experience': experiences.map((e) => {
        'jobTitle': e.jobTitle,
        'company': e.company,
        'startDate': e.startDate,
        'endDate': e.endDate,
        'description': e.description,
        'experienceLevel': e.experienceLevel,
      }).toList(),
      'education': educations.map((e) => {
        'school': e.school,
        'degree': e.degree,
        'year': e.year,
        'gpa': e.gpa,
      }).toList(),
      'skills': skillsList.map((e) => {'name': e.name, 'level': e.level}).toList(),
      'projects': projects.map((e) => {
        'name': e.name,
        'description': e.description,
        'year': e.year,
        'url': e.url,
      }).toList(),
      'selectedTemplate': selectedTemplate.value,
      'language': detectedCvLanguage.value,
      'suggestions': aiSuggestions.toList(),
    };
  }

  List<CvExperience> _mapExperiences(List raw) => raw
      .map((e) => CvExperience(
            jobTitle: e['jobTitle']?.toString() ?? '',
            company: e['company']?.toString() ?? '',
            startDate: e['startDate']?.toString() ?? '',
            endDate: e['endDate']?.toString() ?? '',
            description: e['description']?.toString() ?? '',
            experienceLevel: (e['experienceLevel'] as num?)?.toInt() ?? 1,
          ))
      .toList();

  List<CvEducation> _mapEducations(List raw) => raw
      .map((e) => CvEducation(
            school: e['school']?.toString() ?? '',
            degree: e['degree']?.toString() ?? '',
            year: e['year']?.toString() ?? '',
            gpa: (e['gpa'] as num?)?.toDouble() ?? 0,
          ))
      .toList();

  List<CvSkill> _mapSkills(List raw) => raw
      .map((e) => CvSkill(name: e['name']?.toString() ?? '', level: (e['level'] as num?)?.toInt() ?? 1))
      .toList();

  List<CvProject> _mapProjects(List raw) => raw
      .map((e) => CvProject(
            name: e['name']?.toString() ?? '',
            description: e['description']?.toString() ?? '',
            year: e['year']?.toString() ?? '',
            url: e['url']?.toString() ?? '',
          ))
      .toList();

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    linkedinCtrl.dispose();
    summaryCtrl.dispose();
    jobTitleCtrl.dispose();
    expJobTitleCtrl.dispose();
    companyCtrl.dispose();
    expStartCtrl.dispose();
    expEndCtrl.dispose();
    expDescCtrl.dispose();
    schoolCtrl.dispose();
    degreeCtrl.dispose();
    eduYearCtrl.dispose();
    skillCtrl.dispose();
    projectNameCtrl.dispose();
    projectDescCtrl.dispose();
    projectYearCtrl.dispose();
    projectUrlCtrl.dispose();
    super.onClose();
  }
}
