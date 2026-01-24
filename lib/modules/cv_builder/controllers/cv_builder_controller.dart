import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/pdf_service.dart';
import '../../../data/models/cv_model.dart';

class CvBuilderController extends GetxController {
  final currentStep = 0.obs;

  final totalSteps = 6;

  final cvData = CvModel();
  final selectedTemplate = 1.obs;

  // -- Text Controllers --
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final linkedinCtrl = TextEditingController();

  final summaryCtrl = TextEditingController();

  // Experience
  final jobTitleCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final expStartCtrl = TextEditingController();
  final expEndCtrl = TextEditingController();
  final expDescCtrl = TextEditingController();

  // Education
  final schoolCtrl = TextEditingController();
  final degreeCtrl = TextEditingController();
  final eduYearCtrl = TextEditingController();

  // Skills
  final skillCtrl = TextEditingController();

  // Projects
  final projectNameCtrl = TextEditingController();
  final projectDescCtrl = TextEditingController();
  final projectYearCtrl = TextEditingController();
  final projectUrlCtrl = TextEditingController();

  // -- Lists --
  final experiences = <CvExperience>[].obs;
  final educations = <CvEducation>[].obs;
  final skillsList = <CvSkill>[].obs;
  final projects = <CvProject>[].obs;

  // -- Logic --

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

  // Add Experience
  // استبدل دالة addExperience القديمة بهذه:
  void addExperience() {
    // 1. خففنا الشرط: يكفي المسمى الوظيفي فقط
    if (jobTitleCtrl.text.isNotEmpty) {
      experiences.add(
        CvExperience(
          jobTitle: jobTitleCtrl.text,
          company: companyCtrl.text,
          // عادي تكون فارغة
          startDate: expStartCtrl.text,
          endDate: expEndCtrl.text,
          description: expDescCtrl.text,
        ),
      );

      // 2. تحديث قسري (رغم أن .obs يكفي، لكن للضمان)
      experiences.refresh();

      _clearExpFields();
      Get.back();

      Get.snackbar(
        'Success',
        'Experience Added!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // 3. إضافة رسالة خطأ إذا كان الحقل فارغاً
      Get.snackbar(
        'Error',
        'Job Title is required!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeExperience(int index) => experiences.removeAt(index);

  void _clearExpFields() {
    jobTitleCtrl.clear();
    companyCtrl.clear();
    expStartCtrl.clear();
    expEndCtrl.clear();
    expDescCtrl.clear();
  }

  // Add Education
  void addEducation() {
    if (schoolCtrl.text.isNotEmpty) {
      educations.add(
        CvEducation(
          school: schoolCtrl.text,
          degree: degreeCtrl.text,
          year: eduYearCtrl.text,
        ),
      );
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

  // Add Skill
  void addSkill() {
    if (skillCtrl.text.isNotEmpty) {
      // إضافة المهارة مع مستوى افتراضي (1 = Basic)
      skillsList.add(CvSkill(name: skillCtrl.text, level: 1));
      skillCtrl.clear();
      update();
    }
  }

  void removeSkill(CvSkill skill) => skillsList.remove(skill);

  // Generate PDF
  Future<void> generatePdf() async {
    // 1. تعبئة البيانات
    cvData.fullName = nameCtrl.text;
    cvData.email = emailCtrl.text;
    cvData.phone = phoneCtrl.text;
    cvData.address = addressCtrl.text;
    cvData.linkedin = linkedinCtrl.text;
    cvData.summary = summaryCtrl.text;
    cvData.experience = experiences;
    cvData.education = educations;
    cvData.skills = skillsList;

    if (cvData.fullName.isEmpty) {
      Get.snackbar('Error', 'Please enter at least your name');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await PdfService().generateAndOpenCV(cvData, selectedTemplate.value);
      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }

  void addProject() {
    if (projectNameCtrl.text.isNotEmpty) {
      projects.add(
        CvProject(
          name: projectNameCtrl.text,
          description: projectDescCtrl.text,
          year: projectYearCtrl.text,
          url: projectUrlCtrl.text,
        ),
      );
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
}
