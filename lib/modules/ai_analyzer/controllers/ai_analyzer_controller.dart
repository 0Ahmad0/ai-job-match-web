import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/analysis_result_model.dart';

class AiAnalyzerController extends GetxController {
  // الحالة: 0=Upload, 1=Scanning, 2=Results
  final viewState = 0.obs;

  // نصوص التحميل المتغيرة
  final scanningStatus = ''.obs;

  // النتيجة
  late AnalysisResultModel result;

  // اسم الملف المرفوع
  final fileName = ''.obs;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      fileName.value = result.files.single.name;
    }
  }

  void startAnalysis() async {
    if (fileName.isEmpty) {
      Get.snackbar("Error", "Please upload a file first", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // الانتقال لوضع الفحص
    viewState.value = 1;

    // محاكاة خطوات الذكاء الاصطناعي (سينما)
    final steps = [
      'scanning_1'.tr,
      'scanning_2'.tr,
      'scanning_3'.tr,
      'scanning_4'.tr,
      'scanning_5'.tr,
    ];

    for (var step in steps) {
      scanningStatus.value = step;
      await Future.delayed(const Duration(milliseconds: 1200)); // وقت لكل خطوة
    }

    // توليد نتائج وهمية (لاحقاً اربطها بـ API)
    _generateMockResult();

    // الانتقال للنتائج
    viewState.value = 2;
  }

  void reset() {
    fileName.value = '';
    viewState.value = 0;
  }

  void _generateMockResult() {
    result = AnalysisResultModel(
      score: 78,
      matchedSkills: ['Flutter', 'Dart', 'GetX', 'Clean Architecture', 'Git'],
      missingSkills: ['Unit Testing', 'CI/CD', 'AWS', 'Docker'],
      tips: [
        AnalysisTip(title: "Missing Cloud Skills", description: "Adding AWS or Docker will boost your score by 15%.", isCritical: true),
        AnalysisTip(title: "Summary is too short", description: "Try to expand your summary to include more achievements.", isCritical: false),
        AnalysisTip(title: "File Format", description: "Your PDF is readable by ATS. Good job!", isCritical: false),
      ],
    );
  }
}